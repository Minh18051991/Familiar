package org.example.familiar.repository;

import org.example.familiar.model.MessageAttachment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;

public interface MessageAttachmentRepository extends JpaRepository<MessageAttachment, Integer> {
    Collection<MessageAttachment> findByMessageId(Integer messageId);
}
