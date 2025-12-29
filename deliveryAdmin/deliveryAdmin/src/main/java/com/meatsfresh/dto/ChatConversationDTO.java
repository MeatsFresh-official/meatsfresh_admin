package com.meatsfresh.dto;

import com.meatsfresh.entity.ChatConversation;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ChatConversationDTO {
    private Long id;
    private Long userId;
    private String userName;
    private String userProfileImage;
    private String userRole;
    private LocalDateTime lastMessageTime;
    private String lastMessage;
    private int unreadCount;

    public static ChatConversationDTO fromEntity(ChatConversation entity) {
        ChatConversationDTO dto = new ChatConversationDTO();
        dto.setId(entity.getId());
        dto.setUserId(entity.getUser().getId());
        dto.setUserName(entity.getUser().getName());
        dto.setUserProfileImage(entity.getUser().getProfileImage());
        dto.setUserRole(entity.getUser().getRole().name());
        dto.setLastMessageTime(entity.getLastMessageTime());
        dto.setLastMessage(entity.getLastMessage());
        return dto;
    }
}