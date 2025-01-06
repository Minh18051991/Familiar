package org.example.familiar.service;

import org.example.familiar.dto.CommentDTO;
import org.example.familiar.model.Comment;
import org.example.familiar.model.Post;
import org.example.familiar.repository.CommentRepository;
import org.example.familiar.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class CommentService implements ICommentService {

    @Autowired
    private CommentRepository commentRepository;
    @Autowired
    private PostRepository postRepository;


    @Override
    public CommentDTO addComment(CommentDTO commentDTO) {
        Comment comment = convertToEntity(commentDTO);
        Comment savedComment = commentRepository.save(comment);
        return convertToDTO(savedComment);
    }

    @Override
    public List<CommentDTO> getCommentsByPostId(Integer postId) {
        List<Comment> comments = commentRepository.findByPostIdAndParentCommentIsNullOrderByCreatedAtDesc(postId);
        return comments.stream().map(this::convertToDTO).collect(Collectors.toList());
    }

    @Override
    public List<CommentDTO> getRepliesForComment(Integer parentCommentId) {
        List<Comment> replies = commentRepository.findByParentCommentIdOrderByCreatedAtAsc(parentCommentId);
        return replies.stream().map(this::convertToDTO).collect(Collectors.toList());
    }

    @Override
    public void deleteComment(Integer commentId) {
        commentRepository.deleteById(commentId);
    }

    @Override
    public CommentDTO updateComment(Integer commentId, CommentDTO commentDTO) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new RuntimeException("Comment not found"));
        comment.setContent(commentDTO.getContent());
        Comment updatedComment = commentRepository.save(comment);
        return convertToDTO(updatedComment);
    }

    private CommentDTO convertToDTO(Comment comment) {
        CommentDTO dto = new CommentDTO();
        dto.setId(comment.getId());
        dto.setPostId(comment.getPost().getId());
        dto.setUserId(comment.getUser().getId());
        dto.setParentCommentId(comment.getParentComment() != null ? comment.getParentComment().getId() : null);
        dto.setContent(comment.getContent());
        dto.setLevel(comment.getLevel());
        dto.setIsDeleted(comment.getIsDeleted());
        dto.setCreatedAt(comment.getCreatedAt());
        dto.setUpdatedAt(comment.getUpdatedAt());
        return dto;
    }

    private Comment convertToEntity(CommentDTO dto) {
        Comment comment = new Comment();
        comment.setId(dto.getId());
        if(dto.getPostId() != null) {
           Post post = postRepository.findById(dto.getPostId())
                .orElseThrow(() -> new RuntimeException("Post not found"));
            comment.setPost(post);
        }
        if(dto.getParentCommentId() != null) {
            Comment parentComment = commentRepository.findById(dto.getParentCommentId())
                    .orElseThrow(() -> new RuntimeException("Parent comment not found"));
            comment.setParentComment(parentComment);
        }
        // Bạn cần set Post và User ở đây, có thể cần inject các repository tương ứng
        comment.setContent(dto.getContent());
        comment.setLevel(dto.getLevel());
        comment.setIsDeleted(dto.getIsDeleted());
        comment.setCreatedAt(dto.getCreatedAt());
        comment.setUpdatedAt(dto.getUpdatedAt());
        return comment;
    }
}