package com.example.mybatisplusdemo.common.security;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class Pbkdf2PasswordHasherTest {

    private final Pbkdf2PasswordHasher passwordHasher = new Pbkdf2PasswordHasher();

    @Test
    void hashShouldCreateDistinctValuesForSamePassword() {
        String first = passwordHasher.hash("secret123");
        String second = passwordHasher.hash("secret123");

        assertNotEquals(first, second);
        assertTrue(passwordHasher.matches("secret123", first));
        assertTrue(passwordHasher.matches("secret123", second));
    }

    @Test
    void matchesShouldRejectInvalidInputs() {
        assertFalse(passwordHasher.matches("secret123", null));
        assertFalse(passwordHasher.matches("secret123", "invalid-format"));
        assertFalse(passwordHasher.matches("wrong", passwordHasher.hash("secret123")));
    }

    @Test
    void hashShouldRejectEmptyPassword() {
        assertThrows(IllegalArgumentException.class, () -> passwordHasher.hash(""));
        assertThrows(IllegalArgumentException.class, () -> passwordHasher.hash(null));
    }
}

