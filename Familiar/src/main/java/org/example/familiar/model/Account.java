package org.example.familiar.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Entity
@Table(name = "accounts")
public class Account {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "account_id")
    private Integer accountId;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "username", nullable = false, unique = true, length = 50)
    private String username;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private AccountStatus status = AccountStatus.NORMAL;

    @Column(name = "lock_time")
    private LocalDateTime lockTime;

    @Column(name = "is_deleted")
    private Boolean isDeleted = false;

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    public enum AccountStatus {
        NORMAL, WARNED, BLOCKED
    }
}