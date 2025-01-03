package org.example.familiar.controller.register;

import org.example.familiar.dto.account.AccountDTO;
import org.example.familiar.model.Account;
import org.example.familiar.service.account.IAccountService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/register")
public class RegisterController {

    @Autowired
    private IAccountService accountService;

    // Tạo tài khoản
    @PostMapping("/account/create")
    public ResponseEntity<?> authenticate(@RequestBody AccountDTO accountDTO) throws Exception {

        Account account = new Account();
        BeanUtils.copyProperties(accountDTO, account);
        if (accountService.createAccount(account) != null) {

            return new ResponseEntity<>(account, HttpStatus.OK);
        } else {
            return new ResponseEntity<>("token", HttpStatus.BAD_REQUEST);
        }

    }

    @PostMapping("/account/check-username")
    public ResponseEntity<?> checkAccountByUsername(@RequestBody AccountDTO accountDTO) throws Exception {
        boolean result = !accountService.checkUsernameExists(accountDTO.getUsername());
        return new ResponseEntity<>(result, HttpStatus.OK);
    }
}
