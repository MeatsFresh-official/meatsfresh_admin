package com.meatsfresh.controller;

import com.meatsfresh.dto.ChatConversationDTO;
import com.meatsfresh.dto.ChatMessageDTO;
import com.meatsfresh.entity.ChatConversation;
import com.meatsfresh.entity.ChatMessage;
import com.meatsfresh.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/chat")
public class ChatApiController {

    @Autowired
    private ChatService chatService;

    @GetMapping("/conversations")
    public ResponseEntity<List<ChatConversationDTO>> getAdminConversations(@RequestParam Long adminId) {
        // Convert entities to DTOs before sending
        List<ChatConversationDTO> dtos = chatService.getActiveConversationsForAdmin(adminId);
        return ResponseEntity.ok(dtos);
    }

    @PostMapping("/start/{userId}")
    public ResponseEntity<ChatConversationDTO> startConversation(@PathVariable Long userId, @RequestParam Long adminId) {
        ChatConversation conversation = chatService.findOrCreateConversation(userId, adminId);
        return ResponseEntity.ok(ChatConversationDTO.fromEntity(conversation));
    }

    @GetMapping("/messages/{conversationId}")
    public ResponseEntity<List<ChatMessageDTO>> getMessages(@PathVariable Long conversationId) {
        List<ChatMessage> messages = chatService.getMessagesForConversation(conversationId);
        List<ChatMessageDTO> dtos = messages.stream().map(ChatMessageDTO::fromEntity).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/conversations/find")
    public ResponseEntity<ChatConversationDTO> findConversation(@RequestParam Long userId, @RequestParam Long adminId) {
        return chatService.findOrCreateConversation(userId, adminId) != null ?
                ResponseEntity.ok(ChatConversationDTO.fromEntity(chatService.findOrCreateConversation(userId, adminId))) :
                ResponseEntity.notFound().build();
    }

    @PostMapping("/end/{conversationId}")
    public ResponseEntity<Void> endConversation(@PathVariable Long conversationId) {
        chatService.findConversationById(conversationId).ifPresent(c -> {
            c.setStatus(ChatConversation.ConversationStatus.ENDED);
            chatService.findConversationById(c.getId());
        });
        return ResponseEntity.ok().build();
    }

    @PostMapping("/mark-read/{conversationId}")
    public ResponseEntity<Void> markMessagesAsRead(
            @PathVariable Long conversationId,
            @RequestBody Long userId) {
        chatService.markMessagesAsRead(conversationId, userId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/unread-count/{conversationId}")
    public ResponseEntity<Integer> getUnreadCount(
            @PathVariable Long conversationId,
            @RequestParam Long userId) {
        int count = chatService.getUnreadCount(conversationId, userId);
        return ResponseEntity.ok(count);
    }
}