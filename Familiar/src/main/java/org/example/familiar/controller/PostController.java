package org.example.familiar.controller;

import org.example.familiar.dto.PostDTO;
import org.example.familiar.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/posts")
public class PostController {

    @Autowired
    private PostService postService;

    @GetMapping
    public ResponseEntity<Page<PostDTO>> getAllPosts(Pageable pageable) {
        Page<PostDTO> posts = postService.getAllPosts(pageable);
        if (posts.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(posts);
    }

@PostMapping
public ResponseEntity<PostDTO> createPost(@RequestBody PostDTO postDTO) {
    try {
        PostDTO createdPost = postService.createPost(postDTO);
        return ResponseEntity.ok(createdPost);
    } catch (Exception e) {
        if (e.getMessage().equals("User not found")) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
    }
}

    @GetMapping("/{id}")
    public ResponseEntity<PostDTO> getPostById(@PathVariable Integer id) {
        PostDTO post = postService.getPostById(id);
        if (post == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        return ResponseEntity.ok(post);
    }

    @PutMapping("/{id}")
    public ResponseEntity<PostDTO> updatePost(@PathVariable Integer id,
                                              @RequestBody PostDTO postDTO,
                                              @RequestHeader("User-Id") Integer userId) {
        PostDTO updatedPost = postService.updatePost(id, postDTO, userId);
        if (updatedPost == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        return ResponseEntity.ok(updatedPost);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePost(@PathVariable Integer id,
                                           @RequestHeader("User-Id") Integer userId) {
        postService.deletePost(id, userId);
        if (postService.getPostById(id) != null
                && postService.getPostById(id).getUserId().equals(userId)) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<Page<PostDTO>> getPostsByUserId(@PathVariable Integer userId, Pageable pageable) {
        Page<PostDTO> posts = postService.getPostsByUserId(userId, pageable);
        return ResponseEntity.ok(posts);
    }

}