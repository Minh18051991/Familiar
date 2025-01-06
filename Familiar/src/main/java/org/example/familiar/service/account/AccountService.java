package org.example.familiar.service.account;

import org.example.familiar.dto.login.Login;
import org.example.familiar.model.Account;
import org.example.familiar.repository.account.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AccountService implements IAccountService {

    @Autowired
    private AccountRepository accountRepository;

    public Account getAccountByUsernameAndPassword(Login login) {
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        Account account = accountRepository.findByUsername(login.getUsername());
        if (account != null && passwordEncoder.matches(login.getPassword(), account.getPassword())) {
            return account;
        }
        return null;
    }

    public Account createAccount(Account account) {
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        account.setPassword(passwordEncoder.encode(account.getPassword()));
        if (checkUsernameExists(account.getUsername())) {
            return accountRepository.save(account);
        }
        return null;

    }

    public boolean checkUsernameExists(String username) {
        return accountRepository.findByUsername(username)==null;
    }

    public void updateAccount(Account account) {
        Account updatedAccount = accountRepository.findByUsername(account.getUsername());
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        updatedAccount.setPassword(passwordEncoder.encode(account.getPassword()));
        accountRepository.save(updatedAccount);
    }
}
