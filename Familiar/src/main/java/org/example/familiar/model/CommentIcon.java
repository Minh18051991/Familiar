package org.example.familiar.model;

import lombok.Data;
import jakarta.persistence.*;

@Data
@Entity
@Table(name = "comment_icons")
public class CommentIcon {
    @Id
    @ManyToOne
    @JoinColumn(name = "comment_id")
    private Comment comment;

    @Id
    @ManyToOne
    @JoinColumn(name = "icon_id")
    private Icon icon;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
}