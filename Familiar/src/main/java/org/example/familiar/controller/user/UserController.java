package org.example.familiar.controller.user;

import org.example.familiar.dto.userDTO.UserDTO;
import org.example.familiar.model.User;
import org.example.familiar.service.user.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private IUserService userService;

    @PostMapping("/create")
    public ResponseEntity<?> authenticate(@RequestBody User user) throws Exception {

        userService.createUser(user);
        User newUser = userService.getUserByEmail(user.getEmail()); // Kiểm tra email đã tồn tại hay chưa


        return new ResponseEntity<>(newUser, HttpStatus.OK);


    }

    @GetMapping("detail/{id}")
    public ResponseEntity<?> detailUser(@PathVariable("id") int id) {
        User user = userService.getUserById(id);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    @PutMapping("update/{id}")
    public ResponseEntity<?> updateUser(@PathVariable("id") int id, @RequestBody User user) {
        user.setId(id);
        userService.createUser(user);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    @PostMapping("checkEmail")
    public ResponseEntity<?> checkEmail(@RequestBody User user) {
        boolean isExist = !userService.checkEmailExistence(user.getEmail() );
        return new ResponseEntity<>(isExist, HttpStatus.OK);
    }

    @GetMapping("/search")
    public ResponseEntity<Page<UserDTO>> searchUsers(
            @RequestParam String keyword,
            Pageable pageable) {
        Page<UserDTO> users = userService.searchUsers(keyword, pageable);
        if (users.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
        return ResponseEntity.ok(users);
    }
}
