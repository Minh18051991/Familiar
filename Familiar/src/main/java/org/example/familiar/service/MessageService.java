package org.example.familiar.service;

import org.example.familiar.dto.MessageDTO;
import org.example.familiar.model.Message;
import org.example.familiar.model.MessageAttachment;
import org.example.familiar.model.User;
import org.example.familiar.repository.MessageAttachmentRepository;
import org.example.familiar.repository.MessageRepository;
import org.example.familiar.repository.user.IUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MessageService implements IMessageService {

    @Autowired
    private MessageRepository messageRepository;

    @Autowired
    private IUserRepository userRepository;

    @Autowired
    private MessageAttachmentRepository messageAttachmentRepository;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Transactional
    public MessageDTO createMessage(MessageDTO messageDTO) {
        Message message = createMessageEntity(messageDTO);
        Message savedMessage = messageRepository.save(message);

        List<MessageAttachment> attachments = createAttachments(messageDTO, savedMessage);
        if (!attachments.isEmpty()) {
            messageAttachmentRepository.saveAll(attachments);
        }

        return convertToDTO(savedMessage);
    }

    public MessageDTO getMessageById(Integer id) {
        Message message = messageRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Message not found"));
        return convertToDTO(message);
    }

    @Transactional
    public MessageDTO updateMessage(Integer id, MessageDTO messageDTO) {
        Message message = messageRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Message not found"));

        message.setContent(messageDTO.getContent());
        message.setUpdatedAt(LocalDateTime.now());

        Message updatedMessage = messageRepository.save(message);
        return convertToDTO(updatedMessage);
    }

    @Transactional
    public void deleteMessage(Integer id) {
        Message message = messageRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Message not found"));
        message.setIsDeleted(true);
        messageRepository.save(message);
    }

    public Page<MessageDTO> getMessagesBetweenUsers(Integer user1Id, Integer user2Id, Pageable pageable) {
        Page<Message> messages = messageRepository.findMessagesBetweenUsers(user1Id, user2Id, pageable);
        return messages.map(this::convertToDTO);
    }

    @Transactional
    public MessageDTO sendMessageInRealTime(MessageDTO messageDTO) {
        try {
            Message message = createMessageEntity(messageDTO);
            Message savedMessage = messageRepository.save(message);
            
            List<MessageAttachment> attachments = createAttachments(messageDTO, savedMessage);
            if (!attachments.isEmpty()) {
                messageAttachmentRepository.saveAll(attachments);
            }

            MessageDTO savedMessageDTO = convertToDTO(savedMessage);
            
            // Gửi tin nhắn qua WebSocket
            messagingTemplate.convertAndSendToUser(
                savedMessageDTO.getReceiverUserId().toString(),
                "/queue/messages",
                savedMessageDTO
            );

            return savedMessageDTO;
        } catch (Exception e) {
            // Log lỗi và ném ra ngoại lệ tùy chỉnh
            throw new RuntimeException("Failed to send message", e);
        }
    }

    private Message createMessageEntity(MessageDTO messageDTO) {
        User sender = userRepository.findById(messageDTO.getSenderUserId())
                .orElseThrow(() -> new RuntimeException("Sender not found"));
        User receiver = userRepository.findById(messageDTO.getReceiverUserId())
                .orElseThrow(() -> new RuntimeException("Receiver not found"));

        Message message = new Message();
        message.setSender(sender);
        message.setReceiver(receiver);
        message.setContent(messageDTO.getContent());
        message.setIsDeleted(false);
        message.setCreatedAt(LocalDateTime.now());
        message.setUpdatedAt(LocalDateTime.now());

        return message;
    }

    private List<MessageAttachment> createAttachments(MessageDTO messageDTO, Message message) {
        List<MessageAttachment> attachments = new ArrayList<>();
        if (messageDTO.getAttachmentUrls() != null && !messageDTO.getAttachmentUrls().isEmpty()) {
            for (String url : messageDTO.getAttachmentUrls()) {
                MessageAttachment attachment = new MessageAttachment();
                attachment.setMessage(message);
                attachment.setFileUrl(url);
                attachments.add(attachment);
            }
        }
        return attachments;
    }

    private MessageDTO convertToDTO(Message message) {
        List<String> attachmentUrls = messageAttachmentRepository.findByMessageId(message.getId())
                .stream()
                .map(MessageAttachment::getFileUrl)
                .collect(Collectors.toList());

        MessageDTO dto = new MessageDTO();
        dto.setId(message.getId());
        dto.setSenderUserId(message.getSender().getId());
        dto.setReceiverUserId(message.getReceiver().getId());
        dto.setContent(message.getContent());
        dto.setIsDeleted(message.getIsDeleted());
        dto.setCreatedAt(message.getCreatedAt());
        dto.setUpdatedAt(message.getUpdatedAt());
        dto.setAttachmentUrls(attachmentUrls);

        return dto;
    }
}