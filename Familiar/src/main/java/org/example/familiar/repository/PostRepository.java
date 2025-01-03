package org.example.familiar.repository;

import org.example.familiar.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface PostRepository extends JpaRepository<Post, Integer> {
    Page<Post> findByUser_IdOrderByCreatedAtDesc(Integer userId, Pageable pageable);
    
    @Query("SELECT COUNT(p) FROM Post p WHERE p.user.id = :userId")
    long countByUser_Id(@Param("userId") Integer userId);
}