package com.meatsfresh.repository;

import aj.org.objectweb.asm.commons.Remapper;
import com.meatsfresh.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    List<ChatMessage> findByConversationIdOrderBySentAtAsc(Long conversationId);

    Optional<ChatMessage> findTopByConversationIdOrderBySentAtDesc(Long id);

    @Query("SELECT COUNT(m) FROM ChatMessage m WHERE m.conversation.id = :conversationId " +
            "AND m.isRead = false AND m.sender.id != :userId")
    int countByConversationIdAndIsReadFalseAndSenderIdNot(
            @Param("conversationId") Long conversationId,
            @Param("userId") Long userId);


    @Query("SELECT m FROM ChatMessage m WHERE m.conversation.id = :conversationId " +
            "AND m.isRead = false AND m.sender.id != :userId")
    List<ChatMessage> findByConversationIdAndIsReadFalseAndSenderIdNot(
            @Param("conversationId") Long conversationId,
            @Param("userId") Long userId);
}
