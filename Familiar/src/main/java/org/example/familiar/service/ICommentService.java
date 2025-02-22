package org.example.familiar.service;

import org.example.familiar.dto.CommentDTO;
import java.util.List;

public interface ICommentService {
    CommentDTO addComment(CommentDTO commentDTO);
    List<CommentDTO> getCommentsByPostId(Integer postId);
    void deleteComment(Integer commentId);
    CommentDTO updateComment(Integer commentId, CommentDTO commentDTO);
}