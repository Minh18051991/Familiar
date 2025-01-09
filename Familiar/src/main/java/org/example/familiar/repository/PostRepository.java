package org.example.familiar.repository;

import org.example.familiar.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PostRepository extends JpaRepository<Post, Integer> {
    Page<Post> findByUser_IdAndIsDeletedFalse(Integer userId, Pageable pageable);
    Page<Post> findByIsDeletedFalse(Pageable pageable);
}