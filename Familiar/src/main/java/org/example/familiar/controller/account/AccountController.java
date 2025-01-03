package org.example.familiar.controller.account;

import org.example.familiar.service.account.IAccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/account"  )
public class AccountController {

    @Autowired
    private IAccountService accountService;

}
