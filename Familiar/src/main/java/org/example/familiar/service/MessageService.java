package org.example.familiar.service;

import org.example.familiar.dto.MessageDTO;
import org.example.familiar.model.Message;
import org.example.familiar.model.MessageAttachment;
import org.example.familiar.model.User;
import org.example.familiar.repository.MessageRepository;
import org.example.familiar.repository.MessageAttachmentRepository;
import org.example.familiar.repository.user.IUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MessageService {

    @Autowired
    private MessageRepository messageRepository;

    @Autowired
    private IUserRepository userRepository;

    @Autowired
    private MessageAttachmentRepository messageAttachmentRepository;

    @Transactional
    public MessageDTO createMessage(MessageDTO messageDTO) {
        User sender = userRepository.findById(messageDTO.getSenderUserId())
                .orElseThrow(() -> new RuntimeException("Sender not found"));
        User receiver = userRepository.findById(messageDTO.getReceiverUserId())
                .orElseThrow(() -> new RuntimeException("Receiver not found"));

        Message message = new Message();
        message.setSender(sender);
        message.setReceiver(receiver);
        message.setContent(messageDTO.getContent());
        message.setMessageType(messageDTO.getMessageType());
        message.setIsRead(false);
        message.setIsDeleted(false);
        message.setIsSent(true);
        message.setSessionId(messageDTO.getSessionId());
        message.setCreatedAt(LocalDateTime.now());
        message.setUpdatedAt(LocalDateTime.now());

        message = messageRepository.save(message);

        List<MessageAttachment> attachments = new ArrayList<>();
        if (messageDTO.getAttachmentUrls() != null && !messageDTO.getAttachmentUrls().isEmpty()) {
            for (String url : messageDTO.getAttachmentUrls()) {
                MessageAttachment attachment = new MessageAttachment();
                attachment.setMessage(message);
                attachment.setFileUrl(url);
                attachments.add(attachment);
            }
            messageAttachmentRepository.saveAll(attachments);
        }

        return convertToDTO(message);
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

        message = messageRepository.save(message);
        return convertToDTO(message);
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

    private MessageDTO convertToDTO(Message message) {
        List<String> attachmentUrls = messageAttachmentRepository.findByMessageId(message.getId())
                .stream()
                .map(MessageAttachment::getFileUrl)
                .collect(Collectors.toList());

        return new MessageDTO(
                message.getId(),
                message.getSender().getId(),
                message.getReceiver().getId(),
                message.getContent(),
                message.getMessageType(),
                message.getIsRead(),
                message.getIsDeleted(),
                message.getIsSent(),
                message.getSessionId(),
                message.getCreatedAt(),
                message.getUpdatedAt(),
                attachmentUrls
        );
    }
}