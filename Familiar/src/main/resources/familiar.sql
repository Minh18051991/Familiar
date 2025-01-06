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
    file_name     VARCHAR(255) ,
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
INSERT INTO roles (role_name)
VALUES ('USER'),
       ('ADMIN');
-- Thêm dữ liệu mẫu vào bảng users
INSERT INTO users (first_name, last_name, email, profile_picture_url, bio, date_of_birth, gender, occupation, address)
VALUES
    ('Nguyen', 'Van An', 'nguyenvanan@example.com', 'https://www.pvm.vn/wp-content/uploads/2021/06/avatar-facebook.jpeg', 'Lập trình viên phần mềm.', '1990-01-01', 'Nam', 'Developer', '123 Đường Lê Lợi, Hà Nội'),
    ('Tran', 'Thi Bich', 'tranthibich@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzxIwkTQq40mYW1UPvGITHa6dbw5MfcR-7uOBhJQgcQLyxE95kKfAqpwSsl_byVcPWgwg&usqp=CAU', 'Quản lý dự án.', '1985-05-15', 'Nữ', 'Manager', '456 Đường Nguyễn Huệ, TP.HCM'),
    ('Le', 'Van Canh', 'levancanh@example.com', 'https://taimienphi.vn/tmp/cf/aut/UCJh-I6e5-pGG8-5NjT-O83K-mmJy-eZta-9nqH-anh-dai-dien-dep-cute-1.jpg', 'Nhà thiết kế đồ họa.', '1992-08-20', 'Nam', 'Designer', '789 Đường Trần Phú, Đà Nẵng'),
    ('Pham', 'Thi Dung', 'phamthidung@example.com', 'https://i.pinimg.com/736x/94/be/13/94be1334dbdbf6d78034116f28ad5acd.jpg', 'Nhà khoa học dữ liệu.', '1988-12-12', 'Nữ', 'Scientist', '321 Đường Hùng Vương, Huế'),
    ('Bui', 'Ngoc Trung', 'ngoctrung@example.com', 'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:quality(100)/avatar_trang_0_adb1901700.jpg', 'Kỹ sư', '1988-11-12', 'Nam', 'Kỹ sư', '08 Đường Hùng Vương, Hà Nội'),
    ('Hoang', 'Ngoc Hung', 'hung@example.com', 'https://www.vietnamworks.com/hrinsider/wp-content/uploads/2023/12/anh-den-ngau.jpeg', 'Bác sĩ', '1998-12-18', 'Nam', 'Bác sĩ', '252 Đường Trần Phú, Huế'),
    ('Hoang', 'Ngoc Huyen', 'huyen123@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQA38QCno3QDulKPTpKfOQQSK1OQvvJJ9jWLeDjCPVrPpTCM9XrBiaMk4rJiYRvDdc9m2w&usqp=CAU', 'Công an', '1998-12-02', 'Nữ', 'Công an', '23 Đường Phùng Hưng, Đà Lạt'),
    ('Pham', 'Van Tien', 'vantien122@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBfFftKUOyq6O2fMHcRgEUY9Ipj1450HjSZ8BqBGISHWnaP1gThlGZUjVYA2pMiIhURc0&usqp=CAU', 'Giáo viên', '1999-12-12', 'Nam', 'Giáo viên', '76 Đường Hùng Vương, Hải Phòng'),
    ('Le', 'Quang Hung', 'quanghung121@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-GIVoRghzFELeunJidXvOVorV-Iwe0x_9tA&s', 'Bác sĩ', '1991-12-12', 'Nam', 'Bác sĩ', '76 Đường Hùng Vương, Quảng Ninh'),
    ('Nguyen', 'Trung Dung', 'trungdung222@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIzZv-xMgRA5WCycP2TRNVDxEZDZcQSoXNHw&s', 'Kĩ sư xây dựng', '1998-10-12', 'Nam', 'Kĩ sư xây dựng', '176 Đường Hai Bà Trưng, Hải Phòng'),
    ('Nguyen', 'Hoang Duong', 'hoangduong222@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqekwL2LW2-NBO_FE2f2IjZQnp_1xl-shGcg&s', 'Lập trình viên', '1998-10-12', 'Nam', 'Lập trình viên', '176 Đường Võ Nguyên Giáp, Bình Dương'),
    ('Bui', 'Thi Hanh', 'thihanh112@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwrZPZZQajqumoOQ2aEuXiwqdzwCvoJW2U2Q&s', 'Ngân hàng', '1998-4-12', 'Nam', 'Ngân hàng', '144 Đường Hai Bà Trưng, Daklak'),
    ('Hoang', 'Ngoc Huyen', 'ngochuyen344@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVq9o5HU2DLosRfgWMUNEZhP4Z7oNIGQLkNw&s', 'Ngân hàng', '1997-10-12', 'Nam', 'Ngân hàng', '42 Trần Phú, Thanh Hoá'),
    ('Truong', 'Minh Hung', 'minhhung567@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtkmXzJNuJvLNDIk0yaXDtpVkIoBvKCjhwVg&s', 'Giáo viên', '1988-10-12', 'Nam', 'Giáo viên', '476 Đường Hai Bà Trưng, Nghệ An'),
    ('Nguyen', 'Quang Thinh', 'quangthinh@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGHq9MWK8tFit566FFNdt7YtHX60g5ccTUhg&s', 'Lập trình viên', '1994-10-12', 'Nam', 'Lập trình viên', '176 Đường Hai Bà Trưng, Quảng Bình');
-- Thêm dữ liệu mẫu vào bảng accounts
INSERT INTO accounts (user_id, username, password_hash)
VALUES
    (1, 'an123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (2, 'bich123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (3, 'canh123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (4, 'dung123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (5, 'trung123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (6, 'hung123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (7, 'huyen123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (8, 'tien123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (9, 'hung1234', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (10, 'dung1234', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (11, 'duong123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (12, 'hanh123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (13, 'huyen1234', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (14, 'hung12345', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (15, 'thinh123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO');
-- Thêm dữ liệu mẫu vào bảng account_roles
INSERT INTO account_roles (account_id, role_id)
VALUES
    (1, 1), -- USER role cho nguyenvanan
    (2, 1), -- USER role cho tranthibich
    (3, 1), -- USER role cho levancanh
    (4, 1), -- USER role cho phamthidung
    (4, 2), -- ADMIN role cho phamthidung
    (5, 1),
    (6, 1),
    (7, 1),
    (8, 1),
    (9, 1),
    (10, 1),
    (11, 1),
    (12, 1),
    (13, 1),
    (14, 1),
    (15, 1);
-- Thêm dữ liệu mẫu vào bảng friendships
INSERT INTO friendships (user_id1, user_id2, is_accepted)
VALUES (1, 4, TRUE), -- Nguyen Van An và Pham Thi Dung đã là bạn
       (1, 2, TRUE), -- Nguyen Van An và Tran Thi Bich đã là bạn
       (1, 3, FALSE), -- Nguyen Van An đã gửi lời mời đến Le Van Canh nhưng chưa được chấp nhận
       (2, 4, TRUE), -- Tran Thi Bich và Pham Thi Dung đã là bạn
       (3, 4, TRUE), -- Le Van Canh và Pham Thi Dung đã là bạn
       (2, 5, TRUE),
       (2, 6, TRUE),
       (1, 7, TRUE),
       (2, 8, TRUE),
       (3, 9, TRUE),
       (4, 10, TRUE),
       (9, 1, FALSE),
       (14, 2, FALSE),
       (15, 3, FALSE),
       (11, 1, FALSE),
       (12, 1, FALSE),
       (13, 3, true),
       (15, 4, TRUE),
       (15, 6, TRUE),
       (14, 7, TRUE),
       (15, 11, TRUE);

-- Thêm dữ liệu mẫu vào bảng posts
INSERT INTO posts (user_id, content)
VALUES
    (1, 'This is the first post by Nguyen Van An.'),
    (2, 'Tran Thi Bich shares her thoughts on project management.'),
    (3, 'Le Van Canh showcases his latest graphic design.'),
    (4, 'Pham Thi Dung discusses data science trends.'),
    (5, 'Bui Ngoc Trung talks about engineering challenges.'),
    (6, 'Hoang Ngoc Hung shares medical advice.'),
    (7, 'Hoang Ngoc Huyen discusses law enforcement.'),
    (8, 'Pham Van Tien shares teaching experiences.'),
    (9, 'Le Quang Hung talks about healthcare.'),
    (10, 'Nguyen Trung Dung discusses construction engineering.'),
    (11, 'Nguyen Hoang Duong shares programming tips.'),
    (12, 'Bui Thi Hanh talks about banking.'),
    (13, 'Hoang Ngoc Huyen shares financial advice.'),
    (14, 'Truong Minh Hung discusses education.'),
    (15, 'Nguyen Quang Thinh shares software development insights.');