package com.example.mybatisplusdemo.web.controller;

import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.common.sso.SsoTicketService;
import com.example.mybatisplusdemo.common.utls.SessionUtils;
import com.example.mybatisplusdemo.model.domain.User;
import com.example.mybatisplusdemo.model.domain.Users;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.lang.reflect.Field;

@RestController
@RequestMapping("/api/sso")
public class SsoController {

    private final SsoTicketService ssoTicketService;

    public SsoController(SsoTicketService ssoTicketService) {
        this.ssoTicketService = ssoTicketService;
    }

    @GetMapping("ticket")
    public JsonResponse<IssueTicketResponse> issueTicket() {
        User admin = SessionUtils.getCurrentAdminUserInfo();
        if (admin != null) {
            String loginName = readStringField(admin, "loginName");
            String displayName = readStringField(admin, "remark");
            SsoTicketService.IssuedTicket issued = ssoTicketService.issue(
                    loginName,
                    "admin",
                    "admin_user",
                    displayName
            );
            return JsonResponse.success(toIssueTicketResponse(issued));
        }

        Users biz = SessionUtils.getCurrentBizUserInfo();
        if (biz != null) {
            String role = normalizeBizRole(readStringField(biz, "role"));
            String loginName = readStringField(biz, "loginName");
            String displayName = readStringField(biz, "name");
            SsoTicketService.IssuedTicket issued = ssoTicketService.issue(
                    loginName,
                    role,
                    "user",
                    displayName
            );
            return JsonResponse.success(toIssueTicketResponse(issued));
        }

        return JsonResponse.error("Not logged in");
    }

    @PostMapping("consume")
    public JsonResponse<ConsumeTicketResponse> consumeTicket(@RequestBody ConsumeTicketRequest request) {
        if (request == null || request.ticket == null || request.ticket.isBlank()) {
            return JsonResponse.error("ticket is required");
        }
        SsoTicketService.TicketPayload payload = ssoTicketService.consume(request.ticket.trim());
        if (payload == null) {
            return JsonResponse.error("invalid or expired ticket");
        }
        ConsumeTicketResponse response = new ConsumeTicketResponse(
                payload.loginName(),
                payload.role(),
                payload.sourceTable(),
                payload.displayName(),
                payload.expiresAt().toEpochMilli()
        );
        return JsonResponse.success(response);
    }

    private IssueTicketResponse toIssueTicketResponse(SsoTicketService.IssuedTicket issued) {
        SsoTicketService.TicketPayload payload = issued.payload();
        return new IssueTicketResponse(
                issued.ticket(),
                payload.loginName(),
                payload.role(),
                payload.sourceTable(),
                payload.displayName(),
                payload.expiresAt().toEpochMilli()
        );
    }

    private String normalizeBizRole(String role) {
        if (role == null) {
            return "student";
        }
        String normalized = role.trim().toLowerCase();
        if ("teacher".equals(normalized)) {
            return "teacher";
        }
        return "student";
    }

    private String readStringField(Object target, String fieldName) {
        if (target == null || fieldName == null || fieldName.isBlank()) {
            return null;
        }
        Class<?> type = target.getClass();
        while (type != null) {
            try {
                Field field = type.getDeclaredField(fieldName);
                field.setAccessible(true);
                Object value = field.get(target);
                return value == null ? null : String.valueOf(value);
            } catch (NoSuchFieldException ignored) {
                type = type.getSuperclass();
            } catch (IllegalAccessException ignored) {
                return null;
            }
        }
        return null;
    }

    public static final class ConsumeTicketRequest {
        public String ticket;
    }

    public record IssueTicketResponse(
            String ticket,
            String loginName,
            String role,
            String sourceTable,
            String displayName,
            long expiresAt
    ) {
    }

    public record ConsumeTicketResponse(
            String loginName,
            String role,
            String sourceTable,
            String displayName,
            long expiresAt
    ) {
    }
}
