package org.example.familiar.service.user;

import org.example.familiar.dto.userDTO.UserDTO;
import org.example.familiar.dto.userDTO.UserDTOImpl;
import org.example.familiar.model.User;

public interface IUserService {
    UserDTO findById(Integer id);
    void createUser(User user);
    User getUserById(int id);
    User getUserByEmail(String email);
    boolean checkEmailExistence(String email);
}
