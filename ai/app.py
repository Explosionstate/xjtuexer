"""
Flask Web 服务 - 对话机器人 API 后端
提供 REST API 接口供前端调用
包含语义理解与检索优化功能
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import json
from datetime import datetime
import sys
import os

# 添加当前目录到 Python 路径
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

try:
    from dialogue_robot_core import (
        DialogueRobot, Intent, DocumentType, Priority,
        IntentRecognizer, QuestionRewriter, SemanticCorrector,
        AnswerFormatter, SensitiveWordFilter, FallbackTemplate, FallbackManager
    )
except ImportError as e:
    print(f"✗ 导入失败: {e}")
    print("请确保 dialogue_robot_core.py 与 app.py 在同一目录")
    sys.exit(1)

app = Flask(__name__)
CORS(app)

try:
    robot = DialogueRobot(use_llm=True)
    print("✓ 对话机器人已初始化")
except Exception as e:
    print(f"✗ 机器人初始化警告: {e}")
    print("  将继续运行，但部分功能可能受影响")
    robot = DialogueRobot(use_llm=False)


# ==================== 核心对话API ====================

@app.route('/api/init', methods=['POST'])
def init_conversation():
    """初始化新对话"""
    try:
        conv_id = robot.start_conversation()
        return jsonify({
            "status": "success",
            "conversation_id": conv_id,
            "message": "新对话已创建"
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/send-message', methods=['POST'])
def send_message():
    """发送消息并获取回复 - 包含敏感词过滤和答案格式化"""
    try:
        data = request.json
        user_input = data.get('message', '')

        if not user_input:
            return jsonify({"status": "error", "message": "消息不能为空"}), 400

        # 获取增强的回复（包含敏感词过滤、答案格式化、兜底）
        answer, response_data = robot.get_next_response(user_input)

        return jsonify({
            "status": "success",
            "user_message": user_input,
            "assistant_message": answer,
            "has_sensitive": response_data.get("has_sensitive", False),
            "is_fallback": response_data.get("is_fallback", False),
            "fallback_type": response_data.get("fallback_type", "none"),
            "sources": response_data.get("sources", []),
            "related_questions": response_data.get("related_questions", []),
            "search_results_count": response_data.get("search_results_count", 0),
            "timestamp": response_data.get("timestamp", "")
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/history', methods=['GET'])
def get_history():
    """获取当前对话历史"""
    try:
        history = robot.show_conversation_history()

        return jsonify({
            "status": "success",
            "conversation_id": robot.current_conversation_id,
            "turn_count": robot.get_conversation_turn_count(),
            "messages": history,
            "total_messages": len(history)
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/conversations', methods=['GET'])
def list_conversations():
    """列出所有对话"""
    try:
        conversations = robot.list_conversations()
        return jsonify({
            "status": "success",
            "conversations": conversations,
            "total_count": len(conversations),
            "current_id": robot.current_conversation_id
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/switch-conversation/<conv_id>', methods=['POST'])
def switch_conversation(conv_id):
    """切换到指定对话"""
    try:
        if conv_id not in robot.contexts:
            return jsonify({"status": "error", "message": "对话不存在"}), 404

        robot.current_conversation_id = conv_id
        return jsonify({
            "status": "success",
            "message": f"已切换到对话 {conv_id}",
            "conversation_id": conv_id
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/clear-context', methods=['POST'])
def clear_context():
    """清空当前对话"""
    try:
        robot.clear_context()
        return jsonify({
            "status": "success",
            "message": "对话已清空"
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ==================== 语义理解API ====================

@app.route('/api/intent-recognize', methods=['POST'])
def intent_recognize():
    """识别用户意图"""
    try:
        data = request.json
        user_input = data.get('message', '')

        if not user_input:
            return jsonify({"status": "error", "message": "消息不能为空"}), 400

        intent = robot.intent_recognizer.recognize(user_input)

        return jsonify({
            "status": "success",
            "message": user_input,
            "intent": intent.value,
            "intent_code": intent.name
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/rewrite-question', methods=['POST'])
def rewrite_question():
    """重写问题提升搜索准确率"""
    try:
        data = request.json
        user_input = data.get('message', '')

        if not user_input:
            return jsonify({"status": "error", "message": "消息不能为空"}), 400

        rewritten = robot.question_rewriter.rewrite(user_input)

        return jsonify({
            "status": "success",
            "original": user_input,
            "rewritten": rewritten,
            "changed": user_input != rewritten
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/correct-input', methods=['POST'])
def correct_input():
    """语义纠错 - 纠正输入的错别字"""
    try:
        data = request.json
        user_input = data.get('message', '')

        if not user_input:
            return jsonify({"status": "error", "message": "消息不能为空"}), 400

        corrected = robot.semantic_corrector.correct(user_input)
        correction_info = robot.semantic_corrector.get_correction_info(user_input, corrected)

        return jsonify({
            "status": "success",
            "original": user_input,
            "corrected": corrected,
            "correction_info": correction_info
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/user-intent-history', methods=['GET'])
def user_intent_history():
    """获取用户意图历史"""
    try:
        intent_data = robot.get_user_intent()

        return jsonify({
            "status": "success",
            "total_intents": intent_data["total_intents"],
            "recent_intent": intent_data["recent_intent"],
            "intent_history": intent_data["intent_history"]
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ==================== 知识库检索API ====================

@app.route('/api/search-knowledge', methods=['POST'])
def search_knowledge():
    """增强的知识库搜索"""
    try:
        data = request.json
        query = data.get('query', '')
        kb_names = data.get('kb_names', None)  # 指定知识库
        doc_type = data.get('doc_type', None)  # 文档类型过滤
        threshold = data.get('threshold', 0.3)  # 相似度阈值

        if not query:
            return jsonify({"status": "error", "message": "查询不能为空"}), 400

        # 执行搜索
        doc_type_obj = None
        if doc_type:
            try:
                doc_type_obj = DocumentType[doc_type.upper()]
            except KeyError:
                pass

        results, search_info = robot.search_knowledge(
            query,
            kb_names=kb_names,
            doc_type=doc_type_obj,
            threshold=threshold
        )

        # 格式化搜索结果
        formatted_results = []
        for idx, result in enumerate(results, 1):
            formatted_results.append({
                "rank": idx,
                "question": result.item.question,
                "answer": result.item.answer,
                "doc_type": result.item.doc_type,
                "similarity_score": round(result.similarity_score, 4),
                "matched_keywords": result.matched_keywords,
                "priority": result.item.priority,
                "tags": result.item.tags
            })

        return jsonify({
            "status": "success",
            "query": query,
            "search_info": search_info,
            "results_count": len(formatted_results),
            "results": formatted_results
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/filter-search-results', methods=['POST'])
def filter_search_results_api():
    """过滤搜索结果"""
    try:
        data = request.json
        query = data.get('query', '')
        min_similarity = data.get('min_similarity', 0.5)
        doc_types = data.get('doc_types', None)
        max_results = data.get('max_results', 5)

        if not query:
            return jsonify({"status": "error", "message": "查询不能为空"}), 400

        # 执行搜索
        results, _ = robot.search_knowledge(query)

        # 过滤结果
        filtered = robot.filter_search_results(
            results,
            min_similarity=min_similarity,
            doc_types=doc_types,
            max_results=max_results
        )

        formatted_results = []
        for idx, result in enumerate(filtered, 1):
            formatted_results.append({
                "rank": idx,
                "question": result.item.question,
                "answer": result.item.answer,
                "doc_type": result.item.doc_type,
                "similarity_score": round(result.similarity_score, 4)
            })

        return jsonify({
            "status": "success",
            "query": query,
            "filter_options": {
                "min_similarity": min_similarity,
                "doc_types": doc_types,
                "max_results": max_results
            },
            "results_count": len(formatted_results),
            "results": formatted_results
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ==================== 多知识库管理API ====================

@app.route('/api/knowledge-bases', methods=['GET'])
def get_knowledge_bases():
    """获取所有知识库"""
    try:
        kbs_info = robot.get_all_knowledge_bases()

        return jsonify({
            "status": "success",
            "knowledge_bases": kbs_info,
            "total_count": len(kbs_info)
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/knowledge-base/<kb_name>', methods=['GET'])
def get_knowledge_base(kb_name):
    """获取指定知识库的内容"""
    try:
        kb = robot.kb_manager.get_knowledge_base(kb_name)
        if not kb:
            return jsonify({"status": "error", "message": "知识库不存在"}), 404

        items = kb.get_all_items()
        formatted_items = []
        for item in items.values():
            formatted_items.append({
                "id": item.id,
                "question": item.question,
                "answer": item.answer,
                "doc_type": item.doc_type,
                "tags": item.tags,
                "priority": item.priority,
                "access_level": item.access_level
            })

        return jsonify({
            "status": "success",
            "kb_name": kb_name,
            "items_count": len(formatted_items),
            "items": formatted_items
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/add-knowledge', methods=['POST'])
def add_knowledge():
    """添加知识库条目"""
    try:
        data = request.json
        question = data.get('question', '')
        answer = data.get('answer', '')
        kb_name = data.get('kb_name', 'default')
        doc_type = data.get('doc_type', 'FAQ')

        if not question or not answer:
            return jsonify({"status": "error", "message": "问题和答案不能为空"}), 400

        robot.add_knowledge(question, answer, kb_name=kb_name)

        return jsonify({
            "status": "success",
            "message": f"知识库条目已添加到 {kb_name}",
            "kb_name": kb_name
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ==================== 快捷提问API ====================

@app.route('/api/quick-questions', methods=['GET'])
def get_quick_questions():
    """获取快捷提问列表"""
    try:
        templates = robot.get_quick_questions()
        return jsonify({
            "status": "success",
            "quick_questions": templates,
            "count": len(templates)
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/use-quick-question/<template_id>', methods=['POST'])
def use_quick_question(template_id):
    """使用快捷提问"""
    try:
        result = robot.use_quick_question(template_id)
        if "error" in result:
            return jsonify({"status": "error", "message": result["error"]}), 404

        return jsonify({
            "status": "success",
            "question": result["question"],
            "answer": result["answer"],
            "timestamp": datetime.now().isoformat()
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ==================== 导出API ====================

@app.route('/api/export', methods=['GET'])
def export_conversation():
    """导出对话记录"""
    try:
        format_type = request.args.get('format', 'json')
        exported = robot.export_conversation(format=format_type)

        return jsonify({
            "status": "success",
            "format": format_type,
            "data": exported
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ==================== 模块三：答案格式化与引用 ====================

@app.route('/api/format-answer', methods=['POST'])
def format_answer_endpoint():
    """格式化答案，添加引用和相关问题"""
    try:
        data = request.json
        answer = data.get('answer', '')

        if not answer:
            return jsonify({"status": "error", "message": "答案不能为空"}), 400

        formatted = robot.answer_formatter.format_answer(answer)

        return jsonify({
            "status": "success",
            "formatted": formatted
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/merge-answers', methods=['POST'])
def merge_answers_endpoint():
    """拼接多个答案"""
    try:
        data = request.json
        answers = data.get('answers', [])

        if not answers:
            return jsonify({"status": "error", "message": "答案列表不能为空"}), 400

        merged = "\n\n".join(answers)

        return jsonify({
            "status": "success",
            "merged_answer": merged
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ==================== 模块四：敏感词过滤与兜底 ====================

@app.route('/api/check-sensitive', methods=['POST'])
def check_sensitive():
    """检查文本中的敏感词"""
    try:
        data = request.json
        text = data.get('text', '')

        if not text:
            return jsonify({"status": "error", "message": "文本不能为空"}), 400

        has_sensitive, found_words = robot.sensitive_filter.contains_sensitive_words(text)
        filtered_text = robot.sensitive_filter.filter_text(text) if has_sensitive else text

        return jsonify({
            "status": "success",
            "has_sensitive": has_sensitive,
            "found_words": found_words,
            "count": len(found_words),
            "filtered_text": filtered_text
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/add-sensitive-word', methods=['POST'])
def add_sensitive_word():
    """添加敏感词"""
    try:
        data = request.json
        word = data.get('word', '')

        if not word:
            return jsonify({"status": "error", "message": "敏感词不能为空"}), 400

        success = robot.sensitive_filter.add_word(word)

        if success:
            return jsonify({
                "status": "success",
                "message": f"已添加敏感词: {word}"
            }), 200
        else:
            return jsonify({"status": "error", "message": "添加敏感词失败"}), 400
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/add-sensitive-words-batch', methods=['POST'])
def add_sensitive_words_batch():
    """批量添加敏感词"""
    try:
        data = request.json
        words = data.get('words', [])

        if not words:
            return jsonify({"status": "error", "message": "敏感词列表不能为空"}), 400

        count = robot.sensitive_filter.add_words_batch(words)

        return jsonify({
            "status": "success",
            "message": f"已添加 {count} 个敏感词",
            "added_count": count
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/get-fallback', methods=['POST'])
def get_fallback():
    """获取兜底话术"""
    try:
        data = request.json
        condition = data.get('condition', 'no_result')  # no_result, low_confidence, sensitive

        fallback = robot.fallback_manager.get_fallback(condition)

        return jsonify({
            "status": "success",
            "condition": condition,
            "fallback": fallback
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/set-fallback', methods=['POST'])
def set_fallback():
    """设置兜底话术"""
    try:
        data = request.json
        condition = data.get('condition', '')
        response = data.get('response', '')

        if not condition or not response:
            return jsonify({"status": "error", "message": "条件和话术不能为空"}), 400

        template = FallbackTemplate(
            name=condition,
            condition=condition,
            response=response
        )
        robot.fallback_manager.add_fallback(template)

        return jsonify({
            "status": "success",
            "message": f"已设置兜底话术: {condition}"
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ==================== 系统检查API ====================

@app.route('/api/llm-status', methods=['GET'])
def get_llm_status():
    """获取LLM状态"""
    try:
        status = robot.get_llm_status()
        return jsonify({
            "status": "success",
            "llm_status": status
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


@app.route('/api/health', methods=['GET'])
def health_check():
    """健康检查"""
    llm_status = robot.get_llm_status()
    return jsonify({
        "status": "ok",
        "service": "AI Dialogue Robot API (Enhanced)",
        "version": "2.0",
        "features": [
            "Intent Recognition",
            "Question Rewriting",
            "Semantic Correction",
            "Multi-KB Search",
            "Search Filtering"
        ],
        "llm_connected": llm_status.get('llm_available', False)
    }), 200


# ==================== 主页路由 ====================

@app.route('/', methods=['GET'])
def index():
    """主页 - 返回 index.html"""
    try:
        with open('index.html', 'r', encoding='utf-8') as f:
            return f.read()
    except FileNotFoundError:
        return """
        <html>
        <head>
            <title>AI 智能对话助手 2.0</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 40px; }
                h1 { color: #333; }
                .error { color: #d32f2f; }
                .info { color: #0277bd; margin: 20px 0; }
                .feature { background: #f5f5f5; padding: 10px; margin: 10px 0; }
                pre { background: #f5f5f5; padding: 10px; }
            </style>
        </head>
        <body>
            <h1>🤖 AI 智能对话助手 2.0</h1>
            <div class="error">
                <h2>⚠️ 找不到前端文件</h2>
                <p>index.html 未找到。请确保以下条件：</p>
                <ul>
                    <li>index.html 与 app.py 在同一目录中</li>
                    <li>文件名拼写正确</li>
                    <li>文件未被删除</li>
                </ul>
            </div>
            <div class="info">
                <h3>✨ 新增功能：</h3>
                <div class="feature">
                    <strong>1. 意图识别</strong> - 自动识别用户查询、修改、删除等意图
                </div>
                <div class="feature">
                    <strong>2. 问题重写</strong> - 优化模糊提问的表述，提升搜索准确率
                </div>
                <div class="feature">
                    <strong>3. 语义纠错</strong> - 自动纠正输入的错别字
                </div>
                <div class="feature">
                    <strong>4. 多知识库检索</strong> - 支持跨多个知识库的智能搜索
                </div>
                <div class="feature">
                    <strong>5. 检索过滤</strong> - 按文档类型、相似度等进行精细过滤
                </div>
            </div>
            <div class="info">
                <h3>📚 API 可用端点：</h3>
                <h4>核心对话：</h4>
                <ul>
                    <li>GET /api/health - 健康检查</li>
                    <li>POST /api/init - 初始化对话</li>
                    <li>POST /api/send-message - 发送消息</li>
                    <li>GET /api/history - 获取历史记录</li>
                </ul>
                <h4>语义理解：</h4>
                <ul>
                    <li>POST /api/intent-recognize - 意图识别</li>
                    <li>POST /api/rewrite-question - 问题重写</li>
                    <li>POST /api/correct-input - 语义纠错</li>
                    <li>GET /api/user-intent-history - 意图历史</li>
                </ul>
                <h4>知识库检索：</h4>
                <ul>
                    <li>POST /api/search-knowledge - 增强搜索</li>
                    <li>POST /api/filter-search-results - 过滤搜索结果</li>
                    <li>GET /api/knowledge-bases - 获取所有知识库</li>
                    <li>GET /api/knowledge-base/&lt;name&gt; - 获取指定知识库</li>
                </ul>
            </div>
        </body>
        </html>
        """, 404


# ==================== 错误处理 ====================

@app.errorhandler(404)
def not_found(error):
    """处理404错误"""
    return jsonify({"status": "error", "message": "端点不存在"}), 404


@app.errorhandler(500)
def internal_error(error):
    """处理500错误"""
    return jsonify({"status": "error", "message": "服务器内部错误"}), 500


# ==================== 启动应用 ====================

if __name__ == '__main__':
    print("\n" + "=" * 60)
    print("🤖 AI 智能对话助手 2.0 - Flask 服务")
    print("=" * 60)
    print("\n📍 访问地址：")
    print("  • 网页界面: http://localhost:5000")
    print("  • API 基址: http://localhost:5000/api")
    print("\n🔍 API 文档：")
    print("  • 健康检查: GET http://localhost:5000/api/health")
    print("  • 意图识别: POST http://localhost:5000/api/intent-recognize")
    print("  • 知识库搜索: POST http://localhost:5000/api/search-knowledge")
    print("\n💡 按 Ctrl+C 停止服务")
    print("=" * 60 + "\n")

    app.run(
        debug=True,
        host='0.0.0.0',
        port=5000,
        use_reloader=True
    )