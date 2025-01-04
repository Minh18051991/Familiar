package org.example.familiar.controller;

import org.example.familiar.dto.PostDTO;
import org.example.familiar.service.PostService;
import org.example.familiar.config.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;
import java.io.IOException;
import java.util.List;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api/posts")
public class PostController {

    @Autowired
    private PostService postService;

    @Autowired
    private JwtUtils jwtUtils;

    @GetMapping
    public ResponseEntity<Page<PostDTO>> getAllPosts(Pageable pageable) {
        Page<PostDTO> posts = postService.getAllPosts(pageable);
        return ResponseEntity.ok(posts);
    }

    @PostMapping
    public ResponseEntity<PostDTO> createPost(@RequestPart("post") @Valid PostDTO postDTO,
                                              @RequestPart(value = "files", required = false) List<MultipartFile> files,
                                              @RequestHeader("Authorization") String token) throws IOException {
        Integer userId = jwtUtils.getUserIdFromToken(token);
        postDTO.setUserId(userId);
        PostDTO createdPost = postService.createPost(postDTO, files);
        return new ResponseEntity<>(createdPost, HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PostDTO> getPostById(@PathVariable Integer id) {
        PostDTO post = postService.getPostById(id);
        return ResponseEntity.ok(post);
    }

    @PutMapping("/{id}")
    public ResponseEntity<PostDTO> updatePost(@PathVariable Integer id,
                                              @RequestBody @Valid PostDTO postDTO,
                                              @RequestHeader("Authorization") String token) {
        Integer userId = jwtUtils.getUserIdFromToken(token);
        PostDTO updatedPost = postService.updatePost(id, postDTO, userId);
        return ResponseEntity.ok(updatedPost);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePost(@PathVariable Integer id,
                                           @RequestHeader("Authorization") String token) {
        Integer userId = jwtUtils.getUserIdFromToken(token);
        postService.deletePost(id, userId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<Page<PostDTO>> getPostsByUserId(@PathVariable Integer userId, Pageable pageable) {
        Page<PostDTO> posts = postService.getPostsByUserId(userId, pageable);
        return ResponseEntity.ok(posts);
    }
}