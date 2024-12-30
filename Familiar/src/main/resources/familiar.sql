create database if not exists familiar;
use familiar;

-- Users table (giữ nguyên như cũ)
CREATE TABLE users
(
    user_id             INT AUTO_INCREMENT PRIMARY KEY,
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
    account_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT                NOT NULL,
    username      VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255)       NOT NULL,
    is_active     BOOLEAN                            DEFAULT TRUE,
    status        enum ('normal','warned','blocked') DEFAULT 'normal',
    lock_time     TIMESTAMP                          DEFAULT NULL,
    is_deleted    BOOLEAN                            DEFAULT FALSE,
    last_login    TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- Roles table (giữ nguyên như cũ)
CREATE TABLE roles
(
    role_id   INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(20) UNIQUE NOT NULL
);

-- Account_Roles table (giữ nguyên như cũ)
CREATE TABLE account_roles
(
    account_id INT NOT NULL,
    role_id    INT NOT NULL,
    PRIMARY KEY (account_id, role_id),
    FOREIGN KEY (account_id) REFERENCES accounts (account_id),
    FOREIGN KEY (role_id) REFERENCES roles (role_id)
);

-- Thêm các vai trò mặc định (giữ nguyên như cũ)
INSERT INTO roles (role_name)
VALUES ('USER'),
       ('ADMIN');

-- Icons table (mới)
CREATE TABLE icons
(
    icon_id    INT AUTO_INCREMENT PRIMARY KEY,
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
    post_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    content    TEXT,
    is_deleted BOOLEAN   DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- Post_Icons table (mới)
CREATE TABLE post_icons
(
    post_id INT NOT NULL,
    icon_id INT NOT NULL,
    PRIMARY KEY (post_id, icon_id),
    FOREIGN KEY (post_id) REFERENCES posts (post_id),
    FOREIGN KEY (icon_id) REFERENCES icons (icon_id)
);

-- Attachments table (giữ nguyên như cũ)
CREATE TABLE attachments
(
    attachment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id       INT          NOT NULL,
    file_url      VARCHAR(255) NOT NULL,
    file_name     VARCHAR(255) NOT NULL,
    file_type     VARCHAR(100),
    file_size     INT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts (post_id) ON DELETE CASCADE
);

-- Comments table (cập nhật)
CREATE TABLE comments
(
    comment_id        INT AUTO_INCREMENT PRIMARY KEY,
    post_id           INT  NOT NULL,
    user_id           INT  NOT NULL,
    parent_comment_id INT,
    content           TEXT NOT NULL,
    level             INT       DEFAULT 0,
    is_deleted        BOOLEAN   DEFAULT FALSE,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts (post_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (parent_comment_id) REFERENCES comments (comment_id)
);

-- Comment_Icons table (mới)
CREATE TABLE comment_icons
(
    comment_id INT NOT NULL,
    icon_id    INT NOT NULL,
    PRIMARY KEY (comment_id, icon_id),
    FOREIGN KEY (comment_id) REFERENCES comments (comment_id),
    FOREIGN KEY (icon_id) REFERENCES icons (icon_id)
);

-- Likes table (cập nhật)
CREATE TABLE likes
(
    like_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    post_id    INT,
    comment_id INT,
    icon_id    INT,
    is_active  BOOLEAN   DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (user_id),
    FOREIGN KEY (post_id) REFERENCES posts (post_id),
    FOREIGN KEY (comment_id) REFERENCES comments (comment_id),
    FOREIGN KEY (icon_id) REFERENCES icons (icon_id),
    UNIQUE KEY unique_like_post (user_id, post_id),
    UNIQUE KEY unique_like_comment (user_id, comment_id)
);

-- Friendships table (giữ nguyên như cũ)
CREATE TABLE friendships
(
    friendship_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id1      INT NOT NULL,
    user_id2      INT NOT NULL,
    is_deleted    BOOLEAN   DEFAULT FALSE,

    is_accepted   BOOLEAN   DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id1) REFERENCES users (user_id),
    FOREIGN KEY (user_id2) REFERENCES users (user_id),
    UNIQUE KEY unique_friendship (user_id1, user_id2)
);


-- Messages table (cập nhật)
CREATE TABLE messages
(
    message_id       INT AUTO_INCREMENT PRIMARY KEY,
    sender_user_id   INT  NOT NULL,
    receiver_user_id INT  NOT NULL,
    content          TEXT NOT NULL,
    message_type     VARCHAR(20) DEFAULT 'TEXT',
    is_read          BOOLEAN     DEFAULT FALSE,
    is_deleted       BOOLEAN     DEFAULT FALSE,
    session_id       VARCHAR(255),
    is_sent          BOOLEAN     DEFAULT FALSE,
    created_at       TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP(3),
    updated_at       TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    FOREIGN KEY (receiver_user_id) REFERENCES users (user_id),
    FOREIGN KEY (sender_user_id) REFERENCES users (user_id)
);


-- Message_Icons table (mới)
CREATE TABLE message_icons
(
    message_id INT NOT NULL,
    icon_id    INT NOT NULL,
    PRIMARY KEY (message_id, icon_id),
    FOREIGN KEY (message_id) REFERENCES messages (message_id),
    FOREIGN KEY (icon_id) REFERENCES icons (icon_id)
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
