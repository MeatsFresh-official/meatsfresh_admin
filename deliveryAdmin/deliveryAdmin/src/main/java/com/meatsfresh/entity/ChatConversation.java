package com.meatsfresh.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Data
@Table(name = "chat_conversation")
public class ChatConversation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private Staff user; // The non-admin participant (Manager, Rider, etc.)

    @ManyToOne
    @JoinColumn(name = "admin_id", nullable = false)
    private Staff admin; // The admin participant

    private LocalDateTime createdAt;
    private String lastMessage;
    private LocalDateTime lastMessageTime;

    @Enumerated(EnumType.STRING)
    private ConversationStatus status;

    public enum ConversationStatus {
        ACTIVE,
        ENDED
    }
}