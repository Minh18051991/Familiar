package org.example.familiar.service.user;

import org.example.familiar.dto.userDTO.UserDTO;
import org.example.familiar.dto.userDTO.UserDTOImpl;
import org.example.familiar.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface IUserService {
    UserDTO findById(Integer id);
    void createUser(User user);
    User getUserById(int id);
    User getUserByEmail(String email);
    boolean checkEmailExistence(String email);
    Page<UserDTO> searchUsers(String keyword, Pageable pageable);Page<User> getAllUsers(Pageable pageable);
    Page<User> getAllActiveUsersByName(String name, Pageable pageable);
    void updateUser(User user);
}
