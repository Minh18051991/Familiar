create database if not exists Familiar;
use Familiar;

-- Users table (giữ nguyên như cũ)
CREATE TABLE users
(
    id             INT AUTO_INCREMENT PRIMARY KEY,
    first_name          VARCHAR(50)         NOT NULL,
    last_name           VARCHAR(50)         NOT NULL,
    email               VARCHAR(100) UNIQUE NOT NULL,
    profile_picture_url VARCHAR(255),
    bio                 TEXT,
    date_of_birth       DATE,
    gender              VARCHAR(10),
    occupation          VARCHAR(30),
    address             VARCHAR(100),
    is_deleted          BOOLEAN   DEFAULT FALSE,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Accounts table (giữ nguyên như cũ)
CREATE TABLE accounts
(
    id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT                ,
    username      VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255)       NOT NULL,
    is_active     BOOLEAN                            DEFAULT TRUE,
    status        enum ('normal','warned','blocked') DEFAULT 'normal',
    lock_time     TIMESTAMP                          DEFAULT NULL,
    is_deleted    BOOLEAN                            DEFAULT FALSE,
    last_login    TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

-- Roles table (giữ nguyên như cũ)
CREATE TABLE roles
(
    id   INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(20) UNIQUE NOT NULL
);

-- Account_Roles table (giữ nguyên như cũ)
CREATE TABLE account_roles
(
    id int auto_increment primary key,
    account_id INT NOT NULL,
    role_id    INT NOT NULL,

    FOREIGN KEY (account_id) REFERENCES accounts (id),
    FOREIGN KEY (role_id) REFERENCES roles (id)
);

-- Thêm các vai trò mặc định (giữ nguyên như cũ)
INSERT INTO roles (role_name)
VALUES ('USER'),
       ('ADMIN');

-- Icons table (mới)
CREATE TABLE icons
(
    id    INT AUTO_INCREMENT PRIMARY KEY,
    icon_url   VARCHAR(255) NOT NULL,
    icon_name  VARCHAR(50)  NOT NULL,
    icon_type  VARCHAR(20)  NOT NULL,
    is_deleted BOOLEAN   DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Posts table (cập nhật)
CREATE TABLE posts
(
    id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    content    TEXT,
    is_deleted BOOLEAN   DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

-- Post_Icons table (mới)
CREATE TABLE post_icons
(
    id int auto_increment primary key,
    post_id INT NOT NULL,
    icon_id INT NOT NULL,
    FOREIGN KEY (post_id) REFERENCES posts (id),
    FOREIGN KEY (icon_id) REFERENCES icons (id)
);

-- Attachments table (giữ nguyên như cũ)
CREATE TABLE attachments
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id       INT          NOT NULL,
    file_url      VARCHAR(255) NOT NULL,
    file_name     VARCHAR(255) NOT NULL,
    file_type     VARCHAR(100),
    file_size     INT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE
);

-- Comments table (cập nhật)
CREATE TABLE comments
(
    id        INT AUTO_INCREMENT PRIMARY KEY,
    post_id           INT  NOT NULL,
    user_id           INT  NOT NULL,
    parent_comment_id INT,
    content           TEXT NOT NULL,
    level             INT       DEFAULT 0,
    is_deleted        BOOLEAN   DEFAULT FALSE,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts (id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (parent_comment_id) REFERENCES comments (id)
);

-- Comment_Icons table (mới)
CREATE TABLE comment_icons
(
    id int auto_increment primary key,
    comment_id INT NOT NULL,
    icon_id    INT NOT NULL,
    FOREIGN KEY (comment_id) REFERENCES comments (id),
    FOREIGN KEY (icon_id) REFERENCES icons (id)
);

-- Likes table (cập nhật)
CREATE TABLE likes
(
    id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    post_id    INT,
    comment_id INT,
    icon_id    INT,
    is_active  BOOLEAN   DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (post_id) REFERENCES posts (id),
    FOREIGN KEY (comment_id) REFERENCES comments (id),
    FOREIGN KEY (icon_id) REFERENCES icons (id),
    UNIQUE KEY unique_like_post (user_id, post_id),
    UNIQUE KEY unique_like_comment (user_id, comment_id)
);

-- Friendships table (giữ nguyên như cũ)
CREATE TABLE friendships
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id1      INT NOT NULL,
    user_id2      INT NOT NULL,
    is_deleted    BOOLEAN   DEFAULT FALSE,
    is_accepted   BOOLEAN   DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id1) REFERENCES users (id),
    FOREIGN KEY (user_id2) REFERENCES users (id),
    UNIQUE KEY unique_friendship (user_id1, user_id2)
);


-- Messages table (cập nhật)
CREATE TABLE messages
(
    id     INT AUTO_INCREMENT PRIMARY KEY,
    sender_user_id INT  NOT NULL,
    receiver_user_id INT  NOT NULL,
    content        TEXT NOT NULL,
    message_type   VARCHAR(20) DEFAULT 'TEXT',
    is_read        BOOLEAN     DEFAULT FALSE,
    is_deleted     BOOLEAN     DEFAULT FALSE,
    created_at     TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (receiver_user_id) REFERENCES users (id),
    FOREIGN KEY (sender_user_id) REFERENCES users (id)
);

-- Message_Icons table (mới)
CREATE TABLE message_icons
(
    id int primary key auto_increment,
    message_id INT NOT NULL,
    icon_id    INT NOT NULL,
    FOREIGN KEY (message_id) REFERENCES messages (id),
    FOREIGN KEY (icon_id) REFERENCES icons (id)
);

# -- Denunciation Categories table (giữ nguyên như cũ)
# CREATE TABLE denunciation_categories
    # (
          #     id         INT AUTO_INCREMENT PRIMARY KEY,
          #     name       VARCHAR(50) UNIQUE NOT NULL,
    #     is_deleted BOOLEAN DEFAULT FALSE
    # );
#
# -- Punishments table (giữ nguyên như cũ)
# CREATE TABLE punishments
    # (
          #     id                         INT AUTO_INCREMENT PRIMARY KEY,
          #     user_id_denounce           INT          NOT NULL,
          #     content                    VARCHAR(255) NOT NULL,
    #     created_at                 TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    #     user_id_accused            INT       default NULL,
    #     denunciation_categories_id INT          NOT NULL,
    #     is_deleted                 BOOLEAN   DEFAULT FALSE,
    #     FOREIGN KEY (user_id_denounce) REFERENCES users (user_id),
    #     FOREIGN KEY (user_id_accused) REFERENCES users (user_id),
    #     FOREIGN KEY (denunciation_categories_id) REFERENCES denunciation_categories (id)
    # );


INSERT INTO users (first_name, last_name, email, profile_picture_url, bio)
VALUES
    ('John', 'Doe', 'john.doe@example.com', 'https://example.com/john.jpg', 'I love technology and coding!'),
    ('Jane', 'Smith', 'jane.smith@example.com', 'https://example.com/jane.jpg', 'Passionate about art and design.');

INSERT INTO posts (user_id, content)
VALUES
    (1, 'Just finished a great coding session! #programming'),
    (2, 'Check out my latest art piece! What do you think?'),
    (1, 'Looking for recommendations on good programming books. Any suggestions?');

-- Comments for the first post
INSERT INTO comments (post_id, user_id, content)
VALUES
    (1, 2, 'That''s awesome! What were you working on?');

INSERT INTO comments (post_id, user_id, parent_comment_id, content)
VALUES
    (1, 1, 1, 'I was building a new feature for my personal project. It''s coming along nicely!');

INSERT INTO comments (post_id, user_id, parent_comment_id, content)
VALUES
    (1, 2, 2, 'Sounds interesting! Can''t wait to see it when it''s done.');

-- Comments for the second post
INSERT INTO comments (post_id, user_id, content)
VALUES
    (2, 1, 'Wow, your art is amazing! I love the colors you used.');

INSERT INTO comments (post_id, user_id, parent_comment_id, content)
VALUES
    (2, 2, 4, 'Thank you so much! I was experimenting with a new color palette.');

-- Comments for the third post
INSERT INTO comments (post_id, user_id, content)
VALUES
    (3, 2, 'I highly recommend "Clean Code" by Robert C. Martin. It''s a classic!');

INSERT INTO comments (post_id, user_id, parent_comment_id, content)
VALUES
    (3, 1, 6, 'Thanks for the suggestion! I''ll definitely check it out.');

INSERT INTO comments (post_id, user_id, content)
VALUES
    (3, 2, 'Another great one is "The Pragmatic Programmer" by Andrew Hunt and David Thomas.');
