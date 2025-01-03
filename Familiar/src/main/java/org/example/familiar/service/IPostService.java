package org.example.familiar.service;

import org.example.familiar.dto.PostDTO;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface IPostService {
    PostDTO getPostById(Integer id);
    Page<PostDTO> getAllPosts(Pageable pageable);
    PostDTO createPost(PostDTO postDTO);
    PostDTO updatePost(Integer id, PostDTO postDTO);
    void deletePost(Integer id);
    Page<PostDTO> getPostsByUserId(Integer userId, Pageable pageable);
    List<PostDTO> getRecentPosts(int limit);
    long getPostCountForUser(Integer userId);
}