package org.example.familiar.service;

import org.example.familiar.dto.MessageDTO;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface IMessageService {

    /**
     * Tạo một tin nhắn mới.
     *
     * @param messageDTO Đối tượng DTO chứa thông tin tin nhắn cần tạo
     * @return MessageDTO của tin nhắn đã được tạo
     */
    MessageDTO createMessage(MessageDTO messageDTO);

    /**
     * Lấy tin nhắn theo ID.
     *
     * @param id ID của tin nhắn cần lấy
     * @return MessageDTO của tin nhắn tương ứng
     */
    MessageDTO getMessageById(Integer id);

    /**
     * Cập nhật tin nhắn.
     *
     * @param id ID của tin nhắn cần cập nhật
     * @param messageDTO Đối tượng DTO chứa thông tin cập nhật
     * @return MessageDTO của tin nhắn đã được cập nhật
     */
    MessageDTO updateMessage(Integer id, MessageDTO messageDTO);

    /**
     * Xóa tin nhắn (soft delete).
     *
     * @param id ID của tin nhắn cần xóa
     */
    void deleteMessage(Integer id);

    /**
     * Lấy danh sách tin nhắn giữa hai người dùng.
     *
     * @param user1Id ID của người dùng thứ nhất
     * @param user2Id ID của người dùng thứ hai
     * @param pageable Đối tượng Pageable để hỗ trợ phân trang
     * @return Page<MessageDTO> chứa danh sách tin nhắn đã phân trang
     */
    Page<MessageDTO> getMessagesBetweenUsers(Integer user1Id, Integer user2Id, Pageable pageable);

    /**
     * Gửi tin nhắn trong thời gian thực.
     *
     * @param messageDTO Đối tượng DTO chứa thông tin tin nhắn cần gửi
     * @return MessageDTO của tin nhắn đã được gửi
     */
    MessageDTO sendMessageInRealTime(MessageDTO messageDTO);
}