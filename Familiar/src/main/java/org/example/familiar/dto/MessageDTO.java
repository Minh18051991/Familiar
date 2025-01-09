package org.example.familiar.dto;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class MessageDTO {
    private Integer id;
    private Integer senderUserId;
    private Integer receiverUserId;
    private String content;
    private String messageType;
    private Boolean isRead;
    private Boolean isDeleted;
    private Boolean isSent;
    private String sessionId;
    private List<String> iconIds;
    private List<MultipartFile> attachments;
    private List<String> attachmentUrls;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public MessageDTO(Integer id, Integer id1, Integer id2, String content, String messageType, Boolean isRead, Boolean isDeleted, Boolean isSent, String sessionId, LocalDateTime createdAt, LocalDateTime updatedAt, List<String> attachmentUrls) {
        this.id = id;
        this.senderUserId = id1;
        this.receiverUserId = id2;
        this.content = content;
        this.messageType = messageType;
        this.isRead = isRead;
        this.isDeleted = isDeleted;
        this.isSent = isSent;
        this.sessionId = sessionId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.attachmentUrls = attachmentUrls;
    }

    // Constructor, getters, and setters
}