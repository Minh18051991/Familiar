package org.example.familiar.service;

import org.example.familiar.dto.PostDTO;
import org.example.familiar.model.Post;
import org.example.familiar.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import jakarta.persistence.EntityNotFoundException;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class PostService implements IPostService {

    @Autowired
    private PostRepository postRepository;

    @Override
    public PostDTO getPostById(Integer id) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Post not found with id: " + id));
        return convertToDTO(post);
    }

    @Override
    public Page<PostDTO> getAllPosts(Pageable pageable) {
        return postRepository.findAll(pageable).map(this::convertToDTO);
    }

    @Override
    public PostDTO createPost(PostDTO postDTO) {
        Post post = convertToEntity(postDTO);
        Post savedPost = postRepository.save(post);
        return convertToDTO(savedPost);
    }

    @Override
    public PostDTO updatePost(Integer id, PostDTO postDTO) {
        Post existingPost = postRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Post not found with id: " + id));
        
        existingPost.setContent(postDTO.getContent());
        // Update other fields as necessary
        
        Post updatedPost = postRepository.save(existingPost);
        return convertToDTO(updatedPost);
    }

    @Override
    public void deletePost(Integer id) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Post not found with id: " + id));
        post.setIsDeleted(true);
        postRepository.save(post);
    }

    @Override
    public Page<PostDTO> getPostsByUserId(Integer userId, Pageable pageable) {
        return postRepository.findByUser_IdOrderByCreatedAtDesc(userId, pageable).map(this::convertToDTO);
    }

    @Override
    public List<PostDTO> getRecentPosts(int limit) {
        return postRepository.findAll().stream()
                .limit(limit)
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public long getPostCountForUser(Integer userId) {
        return postRepository.countByUser_Id(userId);
    }

    private PostDTO convertToDTO(Post post) {
        PostDTO dto = new PostDTO();
        dto.setId(post.getId());
        dto.setContent(post.getContent());
        dto.setUserId(post.getUserId());
        dto.setCreatedAt(post.getCreatedAt());
        dto.setUpdatedAt(post.getUpdatedAt());
        dto.setDeleted(post.getIsDeleted());
        return dto;
    }

    private Post convertToEntity(PostDTO dto) {
        Post post = new Post();
        post.setContent(dto.getContent());
        post.setUserId(dto.getUserId());
        // Set other fields as necessary
        return post;
    }
}