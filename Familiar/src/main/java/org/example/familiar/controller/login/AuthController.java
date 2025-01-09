package org.example.familiar.controller.login;


import org.example.familiar.config.JwtUtils;
import org.example.familiar.dto.login.AuthRespone;
import org.example.familiar.dto.login.Login;
import org.example.familiar.model.Account;
import org.example.familiar.model.User;
import org.example.familiar.repository.account.AccountRepository;
import org.example.familiar.service.account.IAccountService;
import org.example.familiar.service.user.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/auth"  )
public class AuthController {

    @Autowired
    private JwtUtils jwtUtil;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private IAccountService accountService;

    @Autowired
    private IUserService userService;



    @PostMapping("/login")
    public ResponseEntity<?> authenticate(@RequestBody Login login) throws Exception {
        Account account = accountService.getAccountByUsernameAndPassword(login);
        if (account != null) {
            User user = userService.getUserById(account.getUser().getId());
            List<String> roles = accountRepository.findRoleNamesByAccountId(account.getId());
            String token = jwtUtil.generateToken(account.getUsername(), roles);

            AuthRespone authRespone = new AuthRespone(token, account.getUsername(), roles,
                    user.getProfilePictureUrl(), account.getUser().getId(), user.getGender());
            return new ResponseEntity<>(authRespone, HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Invalid credentials", HttpStatus.UNAUTHORIZED);
        }
    }


    @GetMapping("/profile")
    public ResponseEntity<String> getUserProfile() {
        // Lấy thông tin Authentication từ SecurityContext
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        // Lấy username từ Authentication (đã được bộ lọc JwtAuthFilter xử lý)
        String username = authentication.getName();

        return new ResponseEntity<>(username, HttpStatus.OK);
    }
}