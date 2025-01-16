package org.example.familiar.controller.user;

import org.example.familiar.dto.userDTO.UserDTO;
import org.example.familiar.model.User;
import org.example.familiar.service.user.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private IUserService userService;

    @PostMapping("/create")
    public ResponseEntity<?> authenticate(@RequestBody User user) throws Exception {
        if (user.getProfilePictureUrl() == null){
            if (user.getGender().equals("Nam")){
                user.setProfilePictureUrl("https://static2.yan.vn/YanNews/2167221/202003/dan-mang-du-trend-thiet-ke-avatar-du-kieu-day-mau-sac-tu-anh-mac-dinh-b0de2bad.jpg");
            }else if (user.getGender().equals("Nữ")){
                user.setProfilePictureUrl("https://antimatter.vn/wp-content/uploads/2022/04/anh-avatar-trang-co-gai-toc-tem.jpg");
            }
        }

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

    @GetMapping("/list")
    public ResponseEntity<Page<User>> getAllUsers(
            @RequestParam(required = false) String name,
            @PageableDefault(size = 20) Pageable pageable) {
        Page<User> users;
        if (name != null && !name.trim().isEmpty()) {
            users = userService.getAllActiveUsersByName(name.trim(), pageable);
        } else {
            users = userService.getAllUsers(pageable);
        }
        return new ResponseEntity<>(users, HttpStatus.OK);
    }

    @PutMapping("/delete/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable("id") int id) {
        User user = userService.getUserById(id);
        userService.updateUser(user);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
