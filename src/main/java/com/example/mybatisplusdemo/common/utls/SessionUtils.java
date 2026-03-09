package com.example.mybatisplusdemo.common.utls;

import com.example.mybatisplusdemo.model.domain.User;
import com.example.mybatisplusdemo.model.domain.Users;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

public final class SessionUtils {

    private static final String ADMIN_KEY = "sessionAdminUser";
    private static final String BIZ_KEY = "sessionBizUser";

    private SessionUtils() {
    }

    private static HttpSession session(boolean create) {
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        return attr.getRequest().getSession(create);
    }

    public static User getCurrentAdminUserInfo() {
        HttpSession s = session(false);
        return s == null ? null : (User) s.getAttribute(ADMIN_KEY);
    }

    public static Users getCurrentBizUserInfo() {
        HttpSession s = session(false);
        return s == null ? null : (Users) s.getAttribute(BIZ_KEY);
    }

    /**
     * 兼容旧调用：默认返回后台管理员会话。
     */
    public static User getCurrentUserInfo() {
        return getCurrentAdminUserInfo();
    }

    public static void saveCurrentAdminUserInfo(User admin) {
        session(true).setAttribute(ADMIN_KEY, admin);
    }

    public static void saveCurrentBizUserInfo(Users biz) {
        session(true).setAttribute(BIZ_KEY, biz);
    }

    /**
     * 兼容旧调用：默认写入后台管理员会话。
     */
    public static void saveCurrentUserInfo(User admin) {
        saveCurrentAdminUserInfo(admin);
    }

    public static void clearAdmin() {
        HttpSession s = session(false);
        if (s != null) {
            s.removeAttribute(ADMIN_KEY);
        }
    }

    public static void clearBiz() {
        HttpSession s = session(false);
        if (s != null) {
            s.removeAttribute(BIZ_KEY);
        }
    }
}
