package com.meatsfresh.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Data
@Table(name = "chat_message")
public class ChatMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "conversation_id", nullable = false)
    private ChatConversation conversation;

    @ManyToOne
    @JoinColumn(name = "sender_id", nullable = false)
    private Staff sender;

    @Column(columnDefinition = "TEXT")
    private String content;

    private LocalDateTime sentAt;

    private boolean isRead;
}