package org.example.familiar.service.user;

import org.example.familiar.model.User;

public interface IUserService {
    void createUser(User user);
    User getUserById(int id);
}
