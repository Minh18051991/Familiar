package org.example.familiar.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Data;

@Data
public class CommentDTO {
    private Integer id;
    private Integer postId;
    private Integer userId;
    private String userFirstName;
    private String userLastName;
    private String userProfilePictureUrl;
    private Integer parentCommentId;
    private List<CommentDTO> replies;
    private String content;
    private Integer level;
    private Boolean isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors, getters, and setters
}