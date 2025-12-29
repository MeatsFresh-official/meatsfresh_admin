package com.meatsfresh.service;

import com.meatsfresh.dto.ChatConversationDTO;
import com.meatsfresh.dto.ChatMessageDTO;
import com.meatsfresh.entity.ChatConversation;
import com.meatsfresh.entity.ChatMessage;
import com.meatsfresh.entity.Staff;
import com.meatsfresh.repository.ChatConversationRepository;
import com.meatsfresh.repository.ChatMessageRepository;
import com.meatsfresh.repository.StaffRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class ChatService {
    @Autowired
    private ChatConversationRepository conversationRepository;

    @Autowired
    private ChatMessageRepository messageRepository;

    @Autowired
    private StaffRepository staffRepository;

    public List<ChatConversationDTO> getActiveConversationsForAdmin(Long adminId) {
        return conversationRepository.findByAdminIdAndStatusOrderByLastMessageTimeDesc(
                        adminId,
                        ChatConversation.ConversationStatus.ACTIVE)
                .stream()
                .map(conv -> {
                    ChatConversationDTO dto = ChatConversationDTO.fromEntity(conv);

                    // Get last message
                    messageRepository.findTopByConversationIdOrderBySentAtDesc(conv.getId())
                            .ifPresent(lastMessage -> {
                                dto.setLastMessage(lastMessage.getContent());
                                dto.setLastMessageTime(lastMessage.getSentAt());
                            });

                    // Get unread count using the new method
                    dto.setUnreadCount(getUnreadCount(conv.getId(), adminId));

                    return dto;
                })
                .collect(Collectors.toList());
    }

    public Optional<ChatConversation> findConversationById(Long id) {
        return conversationRepository.findById(id);
    }

    public List<ChatMessage> getMessagesForConversation(Long conversationId) {
        return messageRepository.findByConversationIdOrderBySentAtAsc(conversationId);
    }

    public ChatConversation findOrCreateConversation(Long userId, Long adminId) {
        return conversationRepository
                .findByUserIdAndAdminIdAndStatus(
                        userId,
                        adminId,
                        ChatConversation.ConversationStatus.ACTIVE)
                .orElseGet(() -> {
                    Staff user = staffRepository.findById(userId)
                            .orElseThrow(() -> new RuntimeException("User not found"));
                    Staff admin = staffRepository.findById(adminId)
                            .orElseThrow(() -> new RuntimeException("Admin not found"));

                    ChatConversation newConversation = new ChatConversation();
                    newConversation.setUser(user);
                    newConversation.setAdmin(admin);
                    newConversation.setCreatedAt(LocalDateTime.now());
                    newConversation.setLastMessageTime(LocalDateTime.now());
                    newConversation.setStatus(ChatConversation.ConversationStatus.ACTIVE);
                    return conversationRepository.save(newConversation);
                });
    }

    public ChatMessageDTO saveMessage(ChatMessageDTO dto) {
        ChatConversation conversation = conversationRepository.findById(dto.getConversationId())
                .orElseThrow(() -> new RuntimeException("Conversation not found"));
        Staff sender = staffRepository.findById(dto.getSenderId())
                .orElseThrow(() -> new RuntimeException("Sender not found"));

        ChatMessage message = new ChatMessage();
        message.setConversation(conversation);
        message.setSender(sender);
        message.setContent(dto.getContent());
        message.setSentAt(LocalDateTime.now());
        message.setRead(false);

        // Update conversation's last message time
        conversation.setLastMessageTime(message.getSentAt());
        conversationRepository.save(conversation);

        ChatMessage savedMessage = messageRepository.save(message);
        return ChatMessageDTO.fromEntity(savedMessage);
    }

    @Transactional
    public void markMessagesAsRead(Long conversationId, Long userId) {
        List<ChatMessage> unreadMessages = messageRepository
                .findByConversationIdAndIsReadFalseAndSenderIdNot(conversationId, userId);

        unreadMessages.forEach(msg -> msg.setRead(true));
        messageRepository.saveAll(unreadMessages);

        // Update the conversation's last message time if needed
        conversationRepository.findById(conversationId).ifPresent(conv -> {
            conv.setLastMessageTime(LocalDateTime.now());
            conversationRepository.save(conv);
        });
    }

    public int getUnreadCount(Long conversationId, Long userId) {
        return messageRepository.countByConversationIdAndIsReadFalseAndSenderIdNot(
                conversationId, userId);
    }

}