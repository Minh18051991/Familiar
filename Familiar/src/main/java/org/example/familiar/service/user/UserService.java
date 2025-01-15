package org.example.familiar.service.user;

import org.example.familiar.dto.userDTO.UserDTO;
import org.example.familiar.dto.userDTO.UserDTOImpl;
import org.example.familiar.model.User;
import org.example.familiar.repository.user.IUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService implements IUserService {
    @Autowired
    private IUserRepository userRepository;

    @Override
    public UserDTO findById(Integer id) {
        User user = userRepository.findById(id).orElse(null);
        if (user != null) {
            UserDTOImpl userDTO = new UserDTOImpl();
            userDTO.setUserId(user.getId());
            userDTO.setUserFirstName(user.getFirstName());
            userDTO.setUserLastName(user.getLastName());
            userDTO.setUserEmail(user.getEmail());
            userDTO.setUserAddress(user.getAddress());
            userDTO.setUserProfilePictureUrl(user.getProfilePictureUrl());
            userDTO.setUserGender(user.getGender());
            userDTO.setUserOccupation(user.getOccupation());
            userDTO.setUserDateOfBirth(user.getDateOfBirth());
            return userDTO;
        }
        return null;
    }
    public void createUser(User user) {
        userRepository.save(user);
    }

    public User getUserById(int id) {
        return userRepository.findById(id).orElse(null);
    }

    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }
    public boolean checkEmailExistence(String email) {
        return userRepository.findByEmail(email)==null;
    }

    public Page<UserDTO> searchUsers(String keyword, Pageable pageable) {
        return userRepository.searchUsers(keyword, pageable).map(user -> {
            UserDTOImpl userDTO = new UserDTOImpl();
            userDTO.setUserId(user.getId());
            userDTO.setUserFirstName(user.getFirstName());
            userDTO.setUserLastName(user.getLastName());
            userDTO.setUserEmail(user.getEmail());
            userDTO.setUserAddress(user.getAddress());
            userDTO.setUserProfilePictureUrl(user.getProfilePictureUrl());
            userDTO.setUserGender(user.getGender());
            userDTO.setUserOccupation(user.getOccupation());
            userDTO.setUserDateOfBirth(user.getDateOfBirth());
            return userDTO;
        });
    }

    @Override
    public Page<User> getAllUsers(Pageable pageable) {
        return userRepository.findAllActiveUsers(pageable);
    }

    @Override
    public Page<User> getAllActiveUsersByName(String name, Pageable pageable) {
        return userRepository.findAllActiveUsersByName(name, pageable);
    }

    public void updateUser(User user) {
        user.setIsDeleted(true);
        userRepository.save(user);
    }
}
