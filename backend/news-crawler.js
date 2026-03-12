
const express = require('express');
const axios = require('axios');
const cheerio = require('cheerio');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// 中间件
app.use(cors());
app.use(express.json());

// 缓存配置
let newsCache = {
    data: [],
    timestamp: null,
    ttl: 60 * 60 * 1000  // 1小时过期
};
async function crawlXJTUNews(pageIndex = 1) {
    try {
        const url = `https://news.xjtu.edu.cn/?page_index=${pageIndex}`;
        console.log(`正在爬取: ${url}`);

        const response = await axios.get(url, {
            timeout: 10000,
            headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
            }
        });

        const $ = cheerio.load(response.data);
        const newsList = [];

        $('div.news-item, li.news-list-item, div.list-item').each((index, element) => {
            const $item = $(element);
            const titleElement = $item.find('a').first();
            const title = titleElement.text().trim();
            const link = titleElement.attr('href');
            const description = $item.find('p, div.desc, div.content').text().trim();
            let dateStr = $item.find('.date, .time, span.time').text().trim();
            if (!dateStr) {
                dateStr = $item.find('span').last().text().trim();
            }
            const imageUrl = $item.find('img').attr('src') || '';

            if (title && link) {
                newsList.push({
                    id: `xjtu-${Date.now()}-${index}`,
                    title: title,
                    description: description || title,
                    image: imageUrl.startsWith('http') ? imageUrl : `https://news.xjtu.edu.cn${imageUrl}`,
                    link: link.startsWith('http') ? link : `https://news.xjtu.edu.cn${link}`,
                    date: dateStr || new Date().toISOString(),
                    source: '西安交通大学新闻网',
                    category: '学技说法'  // 可以根据实际分类修改
                });
            }
        });

        console.log(`成功爬取 ${newsList.length} 条新闻`);
        return newsList;
    } catch (error) {
        console.error('爬虫错误:', error.message);
        throw new Error(`爬虫失败: ${error.message}`);
    }
}
app.get('/api/news', async (req, res) => {
    try {
        const pageIndex = req.query.page || 1;
        const useCache = req.query.cache !== 'false';
        if (useCache && newsCache.data.length > 0 && newsCache.timestamp) {
            const cacheAge = Date.now() - newsCache.timestamp;
            if (cacheAge < newsCache.ttl) {
                console.log('返回缓存数据');
                return res.json({
                    success: true,
                    data: newsCache.data,
                    cached: true,
                    message: '数据来自缓存'
                });
            }
        }
        const newsList = await crawlXJTUNews(pageIndex);
        newsCache.data = newsList;
        newsCache.timestamp = Date.now();

        res.json({
            success: true,
            data: newsList,
            cached: false,
            total: newsList.length,
            message: '数据爬取成功'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message,
            message: '获取新闻失败'
        });
    }
});

app.post('/api/news/refresh', async (req, res) => {
    try {
        newsCache.data = [];
        newsCache.timestamp = null;

        const newsList = await crawlXJTUNews(1);
        newsCache.data = newsList;
        newsCache.timestamp = Date.now();

        res.json({
            success: true,
            data: newsList,
            message: '缓存已刷新'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message,
            message: '刷新失败'
        });
    }
});
app.get('/api/news/:page', async (req, res) => {
    try {
        const pageIndex = req.params.page || 1;
        const newsList = await crawlXJTUNews(pageIndex);

        res.json({
            success: true,
            data: newsList,
            page: pageIndex,
            total: newsList.length
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});
app.get('/health', (req, res) => {
    res.json({ status: 'ok', message: 'News crawler service is running' });
});
app.get('/', (req, res) => {
    res.json({
        message: '西交大新闻爬虫 API',
        endpoints: {
            'GET /api/news': '获取新闻列表',
            'GET /api/news/:page': '获取特定页面的新闻',
            'POST /api/news/refresh': '刷新缓存',
            'GET /health': '健康检查'
        }
    });
});
app.listen(PORT, () => {
    console.log(` 新闻爬虫服务运行在 http://localhost:${PORT}`);
    console.log(' API文档: http://localhost:${PORT}');
});

module.exports = app;