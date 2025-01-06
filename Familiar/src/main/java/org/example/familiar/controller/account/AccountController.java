package org.example.familiar.controller.account;

import org.example.familiar.model.Account;
import org.example.familiar.service.account.IAccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/account")
public class AccountController {

    @Autowired
    private IAccountService accountService;

    @PostMapping("/change-password")
    public ResponseEntity<?> changePassword(@RequestBody Account account) {
    accountService.updateAccount(account);
    return new ResponseEntity<>("ok",HttpStatus.OK)  ;
    }

}
