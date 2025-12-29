package com.meatsfresh.repository;

import com.meatsfresh.dto.ChatConversationDTO;
import com.meatsfresh.entity.ChatConversation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

@Repository
public interface ChatConversationRepository extends JpaRepository<ChatConversation, Long> {
    Optional<ChatConversation> findByUserIdAndAdminIdAndStatus(Long userId, Long adminId, ChatConversation.ConversationStatus status);
    List<ChatConversation> findByAdminIdAndStatusOrderByLastMessageTimeDesc(Long adminId, ChatConversation.ConversationStatus status);

    List<ChatConversation> findByAdminIdAndStatus(Long adminId, ChatConversation.ConversationStatus conversationStatus);
}