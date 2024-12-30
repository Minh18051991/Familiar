package org.example.familiar.model;

import lombok.Data;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.Set;

@Data
@Entity
@Table(name = "icons")
public class Icon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "icon_id")
    private Integer iconId;

    @Column(name = "icon_url", nullable = false)
    private String iconUrl;

    @Column(name = "icon_name", nullable = false)
    private String iconName;

    @Column(name = "icon_type", nullable = false)
    private String iconType;

    @Column(name = "is_deleted")
    private Boolean isDeleted = false;

    @ManyToMany(mappedBy = "icons")
    private Set<Message> messages;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
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