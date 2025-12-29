package com.meatsfresh.controller;

import com.meatsfresh.dto.ChatMessageDTO;
import com.meatsfresh.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
public class WebSocketController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private ChatService chatService;

    @MessageMapping("/chat.send")
    public void processMessage(@Payload ChatMessageDTO chatMessageDTO) {
        // 1. Save the incoming message to the database
        ChatMessageDTO savedMessage = chatService.saveMessage(chatMessageDTO);

        // 2. Define the topic for this specific conversation
        String destination = "/topic/conversation." + savedMessage.getConversationId();

        // 3. Broadcast the saved message to all clients subscribed to this conversation's topic
        messagingTemplate.convertAndSend(destination, savedMessage);
    }
}