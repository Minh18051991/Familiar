package org.example.familiar.service.user;

import org.example.familiar.dto.userDTO.UserDTO;
import org.example.familiar.dto.userDTO.UserDTOImpl;

public interface IUserService {
    UserDTO findById(Integer id);
}
