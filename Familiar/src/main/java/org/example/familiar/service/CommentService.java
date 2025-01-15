package org.example.familiar.service;

import org.example.familiar.dto.CommentDTO;
import org.example.familiar.model.Comment;
import org.example.familiar.model.Post;
import org.example.familiar.model.User;
import org.example.familiar.repository.CommentRepository;
import org.example.familiar.repository.PostRepository;
import org.example.familiar.repository.user.IUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class CommentService implements ICommentService {

    @Autowired
    private CommentRepository commentRepository;
    @Autowired
    private PostRepository postRepository;
    @Autowired
    private IUserRepository userRepository;

    @Override
    public CommentDTO addComment(CommentDTO commentDTO) {
        Comment comment = convertToEntity(commentDTO);
        if (comment.getParentComment() != null) {
            comment.setLevel(comment.getParentComment().getLevel() + 1);
        } else {
            comment.setLevel(0);
        }
        comment.setIsDeleted(false);
        Comment savedComment = commentRepository.save(comment);
        return convertToDTO(savedComment);
    }

    @Override
    public List<CommentDTO> getCommentsByPostId(Integer postId) {
        List<Comment> rootComments = commentRepository.findByPostIdAndParentCommentIsNullAndIsDeletedFalseOrderByCreatedAtDesc(postId);
        List<CommentDTO> result = new ArrayList<>();
        for (Comment rootComment : rootComments) {
            CommentDTO rootDTO = convertToDTO(rootComment);
            rootDTO.setReplies(getRepliesRecursively(rootComment.getId()));
            result.add(rootDTO);
        }
        return result;
    }

    private List<CommentDTO> getRepliesRecursively(Integer parentCommentId) {
        List<Comment> replies = commentRepository.findByParentCommentIdAndIsDeletedFalseOrderByCreatedAtAsc(parentCommentId);
        List<CommentDTO> replyDTOs = new ArrayList<>();
        for (Comment reply : replies) {
            CommentDTO replyDTO = convertToDTO(reply);
            replyDTO.setReplies(getRepliesRecursively(reply.getId()));
            replyDTOs.add(replyDTO);
        }
        return replyDTOs;
    }

    @Override
    public void deleteComment(Integer commentId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new RuntimeException("Comment not found"));
        comment.setIsDeleted(true);
        commentRepository.save(comment);
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
        User user = comment.getUser();
        CommentDTO dto = new CommentDTO();
        dto.setId(comment.getId());
        dto.setPostId(comment.getPost().getId());
        dto.setUserId(user.getId());
        dto.setUserFirstName(user.getFirstName());
        dto.setUserLastName(user.getLastName());
        dto.setUserProfilePictureUrl(user.getProfilePictureUrl());
        dto.setParentCommentId(comment.getParentComment() != null ? comment.getParentComment().getId() : null);
        dto.setContent(comment.getContent());
        dto.setLevel(comment.getLevel());
        dto.setIsDeleted(comment.getIsDeleted());
        dto.setCreatedAt(comment.getCreatedAt());
        dto.setUpdatedAt(comment.getUpdatedAt());
        dto.setReplies(new ArrayList<>());  // Initialize empty list for replies
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
        if(dto.getUserId() != null) {
            User user = userRepository.findById(dto.getUserId())
                    .orElseThrow(() -> new RuntimeException("User not found"));
            comment.setUser(user);
        }
        comment.setContent(dto.getContent());
        comment.setLevel(dto.getLevel());
        comment.setIsDeleted(dto.getIsDeleted());
        comment.setCreatedAt(dto.getCreatedAt());
        comment.setUpdatedAt(dto.getUpdatedAt());
        return comment;
    }
}