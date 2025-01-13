package org.example.familiar.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import org.springframework.web.multipart.MultipartFile;
import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MessageDTO {
    private Integer id;
    private Integer senderUserId;
    private Integer receiverUserId;
    private String content;
    private Boolean isDeleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<MultipartFile> attachments;
    private List<String> attachmentUrls;

    public MessageDTO(Integer id, Integer senderUserId, Integer receiverUserId, String content, 
                      String messageType, Boolean isDeleted, LocalDateTime createdAt, 
                      LocalDateTime updatedAt, List<String> attachmentUrls) {
        this.id = id;
        this.senderUserId = senderUserId;
        this.receiverUserId = receiverUserId;
        this.content = content;
        this.isDeleted = isDeleted;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.attachmentUrls = attachmentUrls;
    }

}