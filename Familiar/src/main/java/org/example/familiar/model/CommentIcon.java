package org.example.familiar.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "comment_icons")
public class CommentIcon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "comment_id")
    private Comment comment;

    @ManyToOne
    @JoinColumn(name = "icon_id")
    private Icon icon;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
}