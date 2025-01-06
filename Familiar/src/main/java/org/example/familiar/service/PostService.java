package org.example.familiar.service;

import org.example.familiar.dto.PostDTO;
import org.example.familiar.model.Post;
import org.example.familiar.model.User;
import org.example.familiar.model.Attachment;
import org.example.familiar.repository.PostRepository;
import org.example.familiar.repository.user.IUserRepository;
import org.example.familiar.repository.AttachmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
@Service
public class PostService {

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private IUserRepository userRepository;

    @Autowired
    private AttachmentRepository attachmentRepository;

    @Autowired
    private FirebaseStorageService firebaseStorageService;

    public Page<PostDTO> getAllPosts(Pageable pageable) {
        Page<Post> posts = postRepository.findAll(pageable);
        return posts.map(this::convertToDTO);
    }

  @Transactional
public PostDTO createPost(PostDTO postDTO) {
    User user = userRepository.findById(postDTO.getUserId())
            .orElseThrow(() -> new RuntimeException("User not found"));

    Post post = new Post();
    post.setUser(user);
    post.setContent(postDTO.getContent());
    post.setCreatedAt(LocalDateTime.now());
    post.setUpdatedAt(LocalDateTime.now());

    post = postRepository.save(post);

    List<Attachment> attachments = new ArrayList<>();
    if (postDTO.getAttachmentUrls() != null && !postDTO.getAttachmentUrls().isEmpty()) {
        for (String url : postDTO.getAttachmentUrls()) {
            Attachment attachment = new Attachment();
            attachment.setPost(post);
            attachment.setFileUrl(url);
            // You might want to extract filename and other details from the URL if possible
            attachments.add(attachment);
        }
        attachmentRepository.saveAll(attachments);
    }

    return convertToDTO(post);
}

    public PostDTO getPostById(Integer id) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Post not found"));
        return convertToDTO(post);
    }

    @Transactional
    public PostDTO updatePost(Integer id, PostDTO postDTO, Integer userId) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        if (!post.getUser().getId().equals(userId)) {
            throw new RuntimeException("You are not authorized to update this post");
        }

        post.setContent(postDTO.getContent());
        post.setUpdatedAt(LocalDateTime.now());

        post = postRepository.save(post);
        return convertToDTO(post);
    }

    @Transactional
    public void deletePost(Integer id, Integer userId) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        if (!post.getUser().getId().equals(userId)) {
            throw new RuntimeException("You are not authorized to delete this post");
        }

        // Delete attachments from Firebase
        List<Attachment> attachments = attachmentRepository.findByPostId(id);
        for (Attachment attachment : attachments) {
            firebaseStorageService.deleteFile(attachment.getFileUrl());
        }

        // Soft delete the post
        post.setIsDeleted(true);
        postRepository.save(post);
    }

    public Page<PostDTO> getPostsByUserId(Integer userId, Pageable pageable) {
        Page<Post> posts = postRepository.findByUserIdAndIsDeletedFalse(userId, pageable);
        return posts.map(this::convertToDTO);
    }

    private PostDTO convertToDTO(Post post) {
        List<String> attachmentUrls = attachmentRepository.findByPostId(post.getId())
                .stream()
                .map(Attachment::getFileUrl)
                .collect(Collectors.toList());

        return new PostDTO(
                post.getId(),
                post.getUser().getId(),
                post.getUser().getFirstName(),
                post.getUser().getLastName(),
                post.getUser().getProfilePictureUrl(),
                post.getContent(),
                post.getIsDeleted(),
                post.getCreatedAt(),
                post.getUpdatedAt(),
                null,  // We don't need to return MultipartFile objects
                attachmentUrls
        );
    }
}