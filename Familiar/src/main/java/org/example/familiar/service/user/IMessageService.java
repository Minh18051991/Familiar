package org.example.familiar.service.user;

import org.example.familiar.model.Message;
import java.util.List;

public interface IMessageService {
    Message saveMessage(Message message);
    List<Message> getMessagesBetweenUsers(Integer senderId, Integer receiverId);
    void markMessageAsRead(Integer messageId);
    void deleteMessage(Integer messageId);
}