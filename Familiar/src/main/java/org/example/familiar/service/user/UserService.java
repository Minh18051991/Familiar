package org.example.familiar.service.user;

import org.example.familiar.model.User;
import org.example.familiar.repository.user.IUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService implements IUserService  {

    @Autowired
    private IUserRepository userRepository;

    @Override
    public void createUser(User user) {
        userRepository.save(user);
    }

    public User getUserById(int id) {
        return userRepository.findById(id).orElse(null);
    }
}
