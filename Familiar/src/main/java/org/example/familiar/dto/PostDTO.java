package org.example.familiar.dto;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class PostDTO {
    private Integer id;
    private Integer userId;
    private String userFirstName;
    private String userLastName;
    private String userProfilePictureUrl;
    private String content;
    private Boolean isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<MultipartFile> attachments;
    private List<String> attachmentUrls;
    private Long commentCount;

    // Constructors

    public PostDTO() {}

    public PostDTO(Integer id, Integer userId, String userFirstName, String userLastName, 
                   String userProfilePictureUrl, String content, Boolean isDeleted, 
                   LocalDateTime createdAt, LocalDateTime updatedAt, 
                   List<MultipartFile> attachments, List<String> attachmentUrls, Long commentCount) {
        this.id = id;
        this.userId = userId;
        this.userFirstName = userFirstName;
        this.userLastName = userLastName;
        this.userProfilePictureUrl = userProfilePictureUrl;
        this.content = content;
        this.isDeleted = isDeleted;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.attachments = attachments;
        this.attachmentUrls = attachmentUrls;
        this.commentCount = commentCount;
    }

    // Getters and Setters

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUserFirstName() {
        return userFirstName;
    }

    public void setUserFirstName(String userFirstName) {
        this.userFirstName = userFirstName;
    }

    public String getUserLastName() {
        return userLastName;
    }

    public void setUserLastName(String userLastName) {
        this.userLastName = userLastName;
    }

    public String getUserProfilePictureUrl() {
        return userProfilePictureUrl;
    }

    public void setUserProfilePictureUrl(String userProfilePictureUrl) {
        this.userProfilePictureUrl = userProfilePictureUrl;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Boolean getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(Boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<MultipartFile> getAttachments() {
        return attachments;
    }

    public void setAttachments(List<MultipartFile> attachments) {
        this.attachments = attachments;
    }

    public List<String> getAttachmentUrls() {
        return attachmentUrls;
    }

    public void setAttachmentUrls(List<String> attachmentUrls) {
        this.attachmentUrls = attachmentUrls;
    }
    public Long getCommentCount() {
        return commentCount;
    }
    public void setCommentCount(Long commentCount) {
        this.commentCount = commentCount;
    }
}