package org.example.familiar.controller.register;

import jakarta.validation.Valid;
import org.example.familiar.dto.account.AccountDTO;
import org.example.familiar.model.Account;
import org.example.familiar.model.User;
import org.example.familiar.service.account.IAccountService;
import org.example.familiar.service.user.IUserService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/register")
public class RegisterController {

    @Autowired
    private IAccountService accountService;

    @Autowired
    private IUserService userService;


    @PostMapping("/account/create")
    public ResponseEntity<?> authenticate(@Valid @RequestBody AccountDTO accountDTO, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            Map<String, String> errors = new HashMap<>();
            for (FieldError error : bindingResult.getFieldErrors()) {
                errors.put(error.getField(), error.getDefaultMessage());
            }
            return new ResponseEntity<>(errors, HttpStatus.BAD_REQUEST);
        }
        Account account = new Account();
        BeanUtils.copyProperties(accountDTO, account);
        User user = userService.getUserById(accountDTO.getUserId());
        account.setUser(user);
        if (accountService.createAccount(account) != null) {
            return new ResponseEntity<>(account, HttpStatus.OK);
        } else {
            return new ResponseEntity<>("Không thể tạo tài khoản", HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/account/check-username")
    public ResponseEntity<?> checkAccountByUsername(@RequestBody AccountDTO accountDTO) throws Exception {
        boolean result = !accountService.checkUsernameExists(accountDTO.getUsername());
        return new ResponseEntity<>(result, HttpStatus.OK);
    }
}
