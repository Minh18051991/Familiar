package org.example.familiar.repository.otp;

import jakarta.transaction.Transactional;
import org.example.familiar.model.Otp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface IOtpRepository extends JpaRepository<Otp, Long> {
    Otp findByUsername(String username);
    void deleteByUsername(String username);
    @Modifying
    @Transactional
    @Query("DELETE FROM Otp o WHERE o.expiresAt <= CURRENT_TIMESTAMP")
    void deleteExpiredOtps();
}
