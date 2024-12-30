package org.example.familiar.model;

import lombok.Data;
import jakarta.persistence.*;

@Data
@Entity
@Table(name = "message_icons",
        uniqueConstraints = {
            @UniqueConstraint(columnNames = {"message_id", "icon_id"})
        })
public class MessageIcon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "message_icon_id")
    private Integer messageIconId;

    @ManyToOne
    @JoinColumn(name = "message_id", nullable = false)
    private Message message;

    @ManyToOne
    @JoinColumn(name = "icon_id", nullable = false)
    private Icon icon;
}