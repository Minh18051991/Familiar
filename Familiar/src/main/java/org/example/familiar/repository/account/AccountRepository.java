package org.example.familiar.repository.account;

import org.example.familiar.model.Account;
import org.example.familiar.model.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface AccountRepository extends JpaRepository<Account, Integer> {
    Account findByUsername(String username);
    boolean existsByUsername(String username);
    Account findByUserEmail(String email);

    @Query("SELECT r.roleName FROM Account a JOIN AccountRole ar ON a.id = ar.account.id JOIN Role r ON ar.role.id = r.id WHERE a.id = :accountId")
    List<String> findRoleNamesByAccountId(@Param("accountId") Integer accountId);
}
