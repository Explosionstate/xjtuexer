package com.example.mybatisplusdemo.common.config;

import com.example.mybatisplusdemo.common.security.Pbkdf2PasswordHasher;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 提供本地密码哈希 Bean，不依赖 Spring Security 的 Web 认证链。
 */
@Configuration
public class SecurityCryptoConfig {

    @Bean
    public Pbkdf2PasswordHasher passwordHasher() {
        return new Pbkdf2PasswordHasher();
    }
}
