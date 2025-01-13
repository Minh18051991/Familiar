package org.example.familiar.service.account;

import org.example.familiar.dto.login.Login;
import org.example.familiar.model.Account;

public interface IAccountService {
    Account getAccountByUsernameAndPassword(Login login);
    Account createAccount(Account account);
    boolean checkUsernameExists(String username);
    void updateAccount(Account account);
    Account getAccountByEmail(String email);
}
