package org.example.familiar.model;


import lombok.Data;
import jakarta.persistence.*;

@Data
@Entity
@Table(name = "post_icons")
public class PostIcon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "post_id")
    private Post post;


    @ManyToOne
    @JoinColumn(name = "icon_id")
    private Icon icon;
}
