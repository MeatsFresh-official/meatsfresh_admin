package com.meatsfresh.dto;

import com.meatsfresh.entity.ChatMessage;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ChatMessageDTO {
    private Long id;
    private Long conversationId;
    private Long senderId;
    private String content;
    private LocalDateTime sentAt;

    public static ChatMessageDTO fromEntity(ChatMessage entity) {
        ChatMessageDTO dto = new ChatMessageDTO();
        dto.setId(entity.getId());
        dto.setConversationId(entity.getConversation().getId());
        dto.setSenderId(entity.getSender().getId());
        dto.setContent(entity.getContent());
        dto.setSentAt(entity.getSentAt());
        return dto;
    }

    // Add a new constructor for convenience
    public ChatMessageDTO(Long conversationId, Long senderId, String content) {
        this.conversationId = conversationId;
        this.senderId = senderId;
        this.content = content;
        this.sentAt = java.time.LocalDateTime.now();
    }
    // Add NoArgsConstructor as well
    public ChatMessageDTO() {}
}