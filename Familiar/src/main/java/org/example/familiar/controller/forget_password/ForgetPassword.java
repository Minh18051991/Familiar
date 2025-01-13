package org.example.familiar.controller.forget_password;

import org.example.familiar.config.JwtUtils;
import org.example.familiar.dto.login.AuthRespone;
import org.example.familiar.model.Account;
import org.example.familiar.model.User;
import org.example.familiar.repository.account.AccountRepository;
import org.example.familiar.service.account.IAccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("api/forget-password")
public class ForgetPassword {

    @Autowired
    private JwtUtils jwtUtil;

    @Autowired
    private IAccountService accountService;

    @Autowired
    private AccountRepository accountRepository;

    @PostMapping("/generate-token")
    public ResponseEntity<?> generateToken(@RequestBody User user) {
        Account account = accountService.getAccountByEmail(user.getEmail());
        String username = account.getUsername();
        List<String> roles = accountRepository.findRoleNamesByAccountId(account.getId());
        AuthRespone authRespone = new AuthRespone(username,jwtUtil.generateToken(username, roles));
        return ResponseEntity.ok(authRespone);
    }
}
