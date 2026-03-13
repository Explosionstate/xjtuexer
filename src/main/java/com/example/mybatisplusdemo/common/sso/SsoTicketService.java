package com.example.mybatisplusdemo.common.sso;

import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class SsoTicketService {

    private static final long DEFAULT_TTL_SECONDS = 120L;

    private final Map<String, TicketPayload> ticketStore = new ConcurrentHashMap<>();

    public IssuedTicket issue(String loginName, String role, String sourceTable, String displayName) {
        if (loginName == null || loginName.isBlank() || role == null || role.isBlank()) {
            throw new IllegalArgumentException("invalid loginName/role");
        }

        cleanupExpired();
        String ticket = UUID.randomUUID().toString().replace("-", "") + UUID.randomUUID().toString().replace("-", "");
        Instant expiresAt = Instant.now().plusSeconds(DEFAULT_TTL_SECONDS);
        TicketPayload payload = new TicketPayload(loginName, role, sourceTable, displayName, expiresAt);
        ticketStore.put(ticket, payload);
        return new IssuedTicket(ticket, payload);
    }

    public TicketPayload consume(String ticket) {
        if (ticket == null || ticket.isBlank()) {
            return null;
        }
        TicketPayload payload = ticketStore.remove(ticket);
        if (payload == null) {
            return null;
        }
        if (payload.expiresAt().isBefore(Instant.now())) {
            return null;
        }
        return payload;
    }

    private void cleanupExpired() {
        Instant now = Instant.now();
        ticketStore.entrySet().removeIf(entry -> entry.getValue().expiresAt().isBefore(now));
    }

    public record TicketPayload(
            String loginName,
            String role,
            String sourceTable,
            String displayName,
            Instant expiresAt
    ) {
    }

    public record IssuedTicket(String ticket, TicketPayload payload) {
    }
}
