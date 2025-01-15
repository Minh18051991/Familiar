package org.example.familiar.repository;

import org.example.familiar.model.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Integer> {
    List<Comment> findByPostIdAndParentCommentIsNullAndIsDeletedFalseOrderByCreatedAtDesc(Integer postId);
    List<Comment> findByParentCommentIdAndIsDeletedFalseOrderByCreatedAtAsc(Integer parentCommentId);
    Long countByPostId(Integer postId);
}