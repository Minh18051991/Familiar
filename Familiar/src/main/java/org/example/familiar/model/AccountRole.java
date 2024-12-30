package org.example.familiar.model;

import lombok.Data;
import jakarta.persistence.*;

@Data
@Entity
@Table(name = "account_roles")
public class AccountRole {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "account_id")
    private Account account;


    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role;
}