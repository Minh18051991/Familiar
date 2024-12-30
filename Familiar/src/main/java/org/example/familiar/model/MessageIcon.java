package org.example.familiar.model;

import lombok.Data;
import jakarta.persistence.*;

@Data
@Entity
@Table(name = "message_icons")
public class MessageIcon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "message_icons_id")
    private Integer messageIconId;

    @ManyToOne
    @JoinColumn(name = "message_id", nullable = false)
    private Message message;

    @ManyToOne
    @JoinColumn(name = "icon_id", nullable = false)
    private Icon icon;
}