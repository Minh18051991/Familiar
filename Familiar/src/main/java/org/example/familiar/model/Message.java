package org.example.familiar.model;

import lombok.Data;
import jakarta.persistence.*;
import java.time.LocalDateTime;


@Data
@Entity
@Table(name = "messages")
public class Message {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "sender_user_id", nullable = false)
    private User sender;

    @ManyToOne
    @JoinColumn(name = "receiver_user_id", nullable = false)
    private User receiver;

    @Column(name = "content", columnDefinition = "TEXT")
    private String content;


    @Column(name = "is_deleted")
    private Boolean isDeleted = false;

    @Column(name = "created_at", columnDefinition = "TIMESTAMP(3)")
    private LocalDateTime createdAt;

    @Column(name = "updated_at", columnDefinition = "TIMESTAMP(3)")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

}