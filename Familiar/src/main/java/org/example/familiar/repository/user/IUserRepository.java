package org.example.familiar.repository.user;

import org.example.familiar.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface IUserRepository extends JpaRepository<User, Integer> , PagingAndSortingRepository<User, Integer> {
    User findByEmail(String email);

    // tim tat ca cac truong
    @Query("SELECT u From User u WHERE " +
            "LOWER(u.firstName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.lastName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.address) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(u.occupation) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    Page<User> searchUsers(@Param("keyword") String keyword, Pageable pageable);

    @Query("SELECT u FROM User u WHERE u.isDeleted = false")
    Page<User> findAllActiveUsers(Pageable pageable);

    @Query("SELECT u FROM User u WHERE u.isDeleted = false AND " +
            "(LOWER(u.firstName) LIKE LOWER(CONCAT('%', :name, '%')) OR " +
            "LOWER(u.lastName) LIKE LOWER(CONCAT('%', :name, '%')) OR " +
            "LOWER(CONCAT(u.firstName, ' ', u.lastName)) LIKE LOWER(CONCAT('%', :name, '%')))")
    Page<User> findAllActiveUsersByName(@Param("name") String name, Pageable pageable);
}
