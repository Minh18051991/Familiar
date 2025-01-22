package org.example.familiar.controller;

import org.example.familiar.dto.MessageDTO;
import org.example.familiar.service.MessageService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;

@Controller
@CrossOrigin("*")
public class WebSocketMessageController {

    private static final Logger logger = LoggerFactory.getLogger(WebSocketMessageController.class);

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private MessageService messageService;

    @MessageMapping("/chat.private")
    public void sendPrivateMessage(@Payload MessageDTO messageDTO) {
        logger.info("Received message: {}", messageDTO);

        MessageDTO savedMessage = messageService.createMessage(messageDTO);
        logger.info("Message saved to database: {}", savedMessage);

        try {
            // Gửi tin nhắn đến người nhận
            messagingTemplate.convertAndSendToUser(
                savedMessage.getReceiverUserId().toString(),
                "/queue/messages",
                savedMessage
            );
            logger.info("Message sent to receiver {}: {}", savedMessage.getReceiverUserId(), savedMessage);

            // Gửi xác nhận về cho người gửi
            messagingTemplate.convertAndSendToUser(
                savedMessage.getSenderUserId().toString(),
                "/queue/messages",
                savedMessage
            );
            logger.info("Confirmation sent to sender {}: {}", savedMessage.getSenderUserId(), savedMessage);
        } catch (Exception e) {
            logger.error("Error sending message: {}", e.getMessage());
        }
    }
}