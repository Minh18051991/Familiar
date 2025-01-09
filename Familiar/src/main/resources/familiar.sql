create database if not exists Familiar;
use Familiar;
-- Users table (giữ nguyên như cũ)
CREATE TABLE users
(
    id            INT AUTO_INCREMENT PRIMARY KEY,
    first_name         VARCHAR(50)        NOT NULL,
    last_name          VARCHAR(50)        NOT NULL,
    email              VARCHAR(100) UNIQUE NOT NULL,
    profile_picture_url VARCHAR(255),
    bio                TEXT,
    date_of_birth      DATE,
    gender             VARCHAR(10),
    occupation         VARCHAR(30),
    address            VARCHAR(100),
    is_deleted         BOOLEAN  DEFAULT FALSE,
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- Accounts table (giữ nguyên như cũ)
CREATE TABLE accounts
(
    id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id      INT               ,
    username     VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255)      NOT NULL,
    is_active    BOOLEAN                           DEFAULT TRUE,
    status       enum ('normal','warned','blocked') DEFAULT 'normal',
    lock_time    TIMESTAMP                         DEFAULT NULL,
    is_deleted   BOOLEAN                           DEFAULT FALSE,
    last_login   TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
);
-- Roles table (giữ nguyên như cũ)
CREATE TABLE roles
(
    id  INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(20) UNIQUE NOT NULL
);
-- Account_Roles table (giữ nguyên như cũ)
CREATE TABLE account_roles
(
    id int auto_increment primary key,
    account_id INT NOT NULL,
    role_id   INT NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts (id),
    FOREIGN KEY (role_id) REFERENCES roles (id)
);
-- Icons table (mới)
CREATE TABLE icons
(
    id   INT AUTO_INCREMENT PRIMARY KEY,
    icon_url  VARCHAR(255) NOT NULL,
    icon_name VARCHAR(50) ,
    icon_type VARCHAR(20) ,
    is_deleted BOOLEAN  DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- Posts table (cập nhật)
CREATE TABLE posts
(
    id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id   INT NOT NULL,
    content   TEXT,
    is_deleted BOOLEAN  DEFAULT FALSE,
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
    post_id      INT         NOT NULL,
    file_url     VARCHAR(255) NOT NULL,
    file_name    VARCHAR(255) ,
    file_type    VARCHAR(100),
    file_size    INT,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE CASCADE
);
-- Comments table (cập nhật)
CREATE TABLE comments
(
    id       INT AUTO_INCREMENT PRIMARY KEY,
    post_id          INT NOT NULL,
    user_id          INT NOT NULL,
    parent_comment_id INT,
    content          TEXT NOT NULL,
    level            INT      DEFAULT 0,
    is_deleted       BOOLEAN  DEFAULT FALSE,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts (id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (parent_comment_id) REFERENCES comments (id)
);
-- Comment_Icons table (mới)
CREATE TABLE comment_icons
(
    id int auto_increment primary key,
    comment_id INT NOT NULL,
    icon_id   INT NOT NULL,
    FOREIGN KEY (comment_id) REFERENCES comments (id),
    FOREIGN KEY (icon_id) REFERENCES icons (id)
);
-- Likes table (cập nhật)
CREATE TABLE likes
(
    id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id   INT NOT NULL,
    post_id   INT,
    comment_id INT,
    icon_id   INT,
    is_active BOOLEAN  DEFAULT TRUE,
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
    user_id1     INT NOT NULL,
    user_id2     INT NOT NULL,
    is_deleted   BOOLEAN  DEFAULT FALSE,
    is_accepted  BOOLEAN  DEFAULT FALSE,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id1) REFERENCES users (id),
    FOREIGN KEY (user_id2) REFERENCES users (id),
    UNIQUE KEY unique_friendship (user_id1, user_id2)
);
-- Messages table (cập nhật)
CREATE TABLE messages
(
    id    INT AUTO_INCREMENT PRIMARY KEY,
    sender_user_id INT NOT NULL,
    receiver_user_id INT NOT NULL,
    content       TEXT NOT NULL,
    message_type  VARCHAR(20) DEFAULT 'TEXT',
    is_read       BOOLEAN    DEFAULT FALSE,
    is_deleted    BOOLEAN    DEFAULT FALSE,
    created_at    TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (receiver_user_id) REFERENCES users (id),
    FOREIGN KEY (sender_user_id) REFERENCES users (id)
);
-- Message_Icons table (mới)
CREATE TABLE message_icons
(
    id int primary key auto_increment,
    message_id INT NOT NULL,
    icon_id   INT NOT NULL,
    FOREIGN KEY (message_id) REFERENCES messages (id),
    FOREIGN KEY (icon_id) REFERENCES icons (id)
);
-- Thêm các vai trò mặc định (giữ nguyên như cũ)
INSERT INTO roles (role_name)
VALUES ('USER'),
       ('ADMIN');

-- Message Attachments table
CREATE TABLE message_attachments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message_id INT NOT NULL,
    file_url VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (message_id) REFERENCES messages(id)
);
-- Thêm dữ liệu mẫu vào bảng users
INSERT INTO users (first_name, last_name, email, profile_picture_url, bio, date_of_birth, gender, occupation, address)
VALUES
    ('Nguyễn', 'Văn An', 'nguyenvanan@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQg6PXuJrNaOGsMtF8O3dL3LtpCwmZgbEVQHA&s', 'Lập trình viên phần mềm.', '1990-01-01', 'Nam', 'Lập trình viên', '123 Đường Lê Lợi, Hà Nội'),
    ('Trần', 'Thị Bích', 'tranthibich@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSl-4IT0nr1-P3RtiSq5jyVgE_p8tev3uMQJg&s', 'Quản lý dự án.', '1985-05-15', 'Nữ', 'Quản lý dự án', '456 Đường Nguyễn Huệ, TP.HCM'),
    ('Lê', 'Văn Cảnh', 'levancanh@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5PGZRpYiT82tvQy9bzK4ONnwWsqxmFRXnQg&s', 'Nhà thiết kế đồ họa.', '1992-08-20', 'Nam', 'Nhà thiết kế đồ họa', '789 Đường Trần Phú, Đà Nẵng'),
    ('Phạm', 'Thị Dung', 'phamthidung@example.com', 'https://i.pinimg.com/736x/94/be/13/94be1334dbdbf6d78034116f28ad5acd.jpg', 'Nhà khoa học dữ liệu.', '1988-12-12', 'Nữ', 'Nhà khoa học dữ liệu', '321 Đường Hùng Vương, Huế'),
    ('Bùi', 'Ngọc Trung', 'ngoctrung@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFOXnnge5fMIl4nZXCD50mm735YVFK1vJ7uQ&s', 'Kỹ sư', '1988-11-12', 'Nam', 'Kỹ sư', '08 Đường Hùng Vương, Hà Nội'),
    ('Hoàng', 'Ngọc Hưng', 'hung@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNd6LwTB9AmbI_2RDrZ-oGd4rjU5UdaDjMuQ&s', 'Bác sĩ', '1998-12-18', 'Nam', 'Bác sĩ', '252 Đường Trần Phú, Huế'),
    ('Hoàng', 'Ngọc Huyền', 'huyen123@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAOHYeQiPdEQ0b11_4ighnRI4gAOtva9_jCg&s', 'Công an', '1998-12-02', 'Nữ', 'Công an', '23 Đường Phùng Hưng, Đà Lạt'),
    ('Phạm', 'Văn Tiến', 'vantien122@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTqivewQvwRZLuYtLD3Kbbd6H1lPL8wrZMTQ&s', 'Giáo viên', '1999-12-12', 'Nam', 'Giáo viên', '76 Đường Hùng Vương, Hải Phòng'),
    ('Lê', 'Quang Hùng', 'quanghung121@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShdAH2jp4pmeyUtKpmTFpYAM0UyV-0KEJDOw&s', 'Bác sĩ', '1991-12-12', 'Nam', 'Bác sĩ', '76 Đường Hùng Vương, Quảng Ninh'),
    ('Nguyễn', 'Trung Dũng', 'trungdung222@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIzZv-xMgRA5WCycP2TRNVDxEZDZcQSoXNHw&s', 'Kĩ sư xây dựng', '1998-10-12', 'Nam', 'Kĩ sư xây dựng', '176 Đường Hai Bà Trưng, Hải Phòng'),
    ('Nguyễn', 'Hoàng Dương', 'hoangduong222@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqekwL2LW2-NBO_FE2f2IjZQnp_1xl-shGcg&s', 'Lập trình viên', '1998-10-12', 'Nam', 'Lập trình viên', '176 Đường Võ Nguyên Giáp, Bình Dương'),
    ('Bùi', 'Thị Hạnh', 'thihanh112@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwrZPZZQajqumoOQ2aEuXiwqdzwCvoJW2U2Q&s', 'Ngân hàng', '1998-4-12', 'Nam', 'Ngân hàng', '144 Đường Hai Bà Trưng, Daklak'),
    ('Hoàng', 'Ngọc Huyền', 'ngochuyen344@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVq9o5HU2DLosRfgWMUNEZhP4Z7oNIGQLkNw&s', 'Ngân hàng', '1997-10-12', 'Nam', 'Ngân hàng', '42 Trần Phú, Thanh Hoá'),
    ('Trương', 'Minh Hưng', 'minhhung567@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtkmXzJNuJvLNDIk0yaXDtpVkIoBvKCjhwVg&s', 'Giáo viên', '1988-10-12', 'Nam', 'Giáo viên', '476 Đường Hai Bà Trưng, Nghệ An'),
    ('Nguyễn', 'Quang Thịnh', 'quangthinh@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGHq9MWK8tFit566FFNdt7YtHX60g5ccTUhg&s', 'Lập trình viên', '1994-10-12', 'Nam', 'Lập trình viên', '176 Đường Hai Bà Trưng, Quảng Bình');
INSERT INTO users (first_name, last_name, email, profile_picture_url, bio, date_of_birth, gender, occupation, address)
VALUES
    ('Trần', 'Hồng Phúc', 'phuc123@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTtJ1R3JMyJK-5ypd9jA7FbSDyGb5Km8emnQ&s', 'Lập trình viên phần mềm.', '1990-01-01', 'Nam', 'Lập trình viên', '144 Đường Lê Lợi, Hà Nội'),
    ('Hoàng', 'Vân Anh', 'anh12345@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSaFne3ZhcpDbFc1hqrdNRtmE4cB8nuLCgGnw&s', 'Ngân hàng', '1990-01-03', 'Nữ', 'Ngân hàng', '177 Đường Lê Lợi, Hà Nội'),
    ('Võ', 'Hoài Linh', 'linn111@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThl42MwkbB-Fq2892irytLd13Jn4rBi_c2lQ&s', 'Kĩ sư cầu đường', '1990-11-01', 'Nam', 'Kĩ sư cầu đường', '123 Đường Lê Hồng Phong, Hà Nội'),
    ('Bùi', 'Văn Trung', 'trung68@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR22Ujota8OXVQ-70XlkKil8ufYE2mivIJ4Gw&s', 'Kĩ sư xây dựng', '1994-01-01', 'Nam', 'Kĩ sư xây dựng', '123 Đường Lê Lợi, Huế'),
    ('Hồ', 'Thành Trung', 'trung2345@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGHq9MWK8tFit566FFNdt7YtHX60g5ccTUhg&s', 'Cầu thủ bóng đá', '1990-01-01', 'Nam', 'Cầu thủ bóng đá', '123 Đường Hai Bà Trưng, Hà Nội'),
    ('Nguyễn', 'Thị Hồng', 'hong222@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJsUXVw598oXoJnJZ4_3UMXxKWKce6T3tO-g&s', 'Giáo viên', '1990-01-01', 'Nữ', 'Giáo viên', '123 Đường Lê Lợi, Hà Tĩnh'),
    ('Lý', 'Nam Trực', 'truc222@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZOt5y65YnvXq3nQRSj5TxsqtZKsz9ChIn1Q&s', 'Sĩ quan quân đội', '1993-01-01', 'Nam', 'Sĩ quan quân đội', '123 Đường Nam Kì Khởi Nghĩa, Sài Gòn'),
    ('Hoàng', 'Thái Văn', 'van000@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRaUR0sJmtEF3m_sG4OtXtVtpGlkLEJT3KEnQ&s', 'Lập trình viên phần mềm.', '1990-01-01', 'Nam', 'Lập trình viên', '121 Đường Lê Lợi, Hà Nội'),
    ('Trần', 'Hạnh Phúc', 'phuc267@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZ1WrCQUxhuhLL7Ia6Y2B5dLuSeFqL-Q7IWw&s', 'Kế toán', '1992-01-01', 'Nữ', 'Kế toán', '1113 Đường Lê Lợi, Hà Nội'),
    ('Nguyễn', 'Hồng Hạnh', 'hanh657@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRROsPyTGkI4dZzgsHkrlyV_Swj3g6OR3is5Q&s', 'Giáo viên tiểu học', '1990-01-21', 'Nữ', 'Giáo viên tiểu học', '123 Đường Lê Lợi, Huế');

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
INSERT INTO accounts (user_id, username, password_hash)
VALUES
    (16, 'phuc123456', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (17, 'anh123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (18, 'linh123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (19, 'trung1234', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (20, 'trung1235', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (21, 'hong123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (22, 'truc123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (23, 'van123', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (24, 'phuc1234', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (25, 'hanh12345', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO');
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
INSERT INTO account_roles (account_id, role_id)
VALUES
    (16, 1),
    (17, 1),
    (18, 1),
    (19, 1),
    (20, 1),
    (21, 1),
    (22, 1),
    (23, 1),
    (24, 1),
    (25, 1);
-- Thêm dữ liệu mẫu vào bảng friendships
INSERT INTO friendships (user_id1, user_id2, is_accepted)
VALUES (1, 4, TRUE),
       (1, 2, TRUE),
       (1, 3, FALSE),
       (2, 4, TRUE),
       (3, 4, TRUE),
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
       (15, 11, TRUE),
       (16, 2, TRUE),
       (17, 2, TRUE),
       (18, 2, TRUE),
       (19, 2, TRUE),
       (16, 4, false),
       (17, 4, TRUE),
       (18, 11, TRUE),
       (20,3, TRUE),
       (21, 3, TRUE),
       (22, 5, TRUE),
       (16, 5, TRUE),
       (17, 7, TRUE),
       (18, 3, TRUE),
       (19, 11, TRUE),
       (20, 12, TRUE),
       (21, 16, TRUE),
       (22, 7, TRUE),
       (23, 6, TRUE),
       (24, 4, TRUE),
       (25, 7, TRUE),
       (16,17, TRUE),
       (17, 17, TRUE),
       (18, 25, TRUE),
       (19, 14, TRUE),
       (20, 13, TRUE),
       (21, 9, TRUE),
       (22, 17, TRUE),
       (23, 17, TRUE),
       (24, 19, TRUE),
       (25, 16, TRUE),
       (21, 11, TRUE);
INSERT INTO friendships (user_id1, user_id2, is_accepted)
VALUES(19, 1, TRUE),
      (22, 1, TRUE),
      (23, 1, TRUE);

-- Thêm dữ liệu mẫu vào bảng posts
INSERT INTO posts (user_id, content)
VALUES
    (1, 'Đây là bài đăng đầu tiên của Nguyễn Văn An.'),
    (2, 'Trần Thị Bích chia sẻ suy nghĩ của cô ấy về quản lý dự án.'),
    (3, 'Lê Văn Cảnh giới thiệu thiết kế đồ họa mới nhất của anh ấy.'),
    (4, 'Phạm Thị Dung thảo luận về xu hướng khoa học dữ liệu.'),
    (5, 'Bùi Ngọc Trung nói về những thách thức trong kỹ thuật.'),
    (6, 'Hoàng Ngọc Hùng chia sẻ lời khuyên y tế.'),
    (7, 'Hoàng Ngọc Huyền thảo luận về thực thi pháp luật.'),
    (8, 'Phạm Văn Tiến chia sẻ kinh nghiệm giảng dạy.'),
    (9, 'Lê Quang Hùng nói về chăm sóc sức khỏe.'),
    (10, 'Nguyễn Trung Dũng thảo luận về kỹ thuật xây dựng.'),
    (11, 'Nguyễn Hoàng Dương chia sẻ mẹo lập trình.'),
    (12, 'Bùi Thị Hạnh nói về ngân hàng.'),
    (13, 'Hoàng Ngọc Huyền chia sẻ lời khuyên tài chính.'),
    (14, 'Trương Minh Hùng thảo luận về giáo dục.'),
    (15, 'Nguyễn Quang Thịnh chia sẻ hiểu biết về phát triển phần mềm.');

-- Thêm dữ liệu mẫu vào bảng comments
INSERT INTO comments (post_id, user_id, parent_comment_id, content, level)
VALUES
    (1, 2, NULL, 'Bài viết hay quá, Nguyễn Văn An!', 0),
    (1, 3, 1, 'Tôi đồng ý với bạn, Trần Thị Bích.', 1),
    (2, 1, NULL, 'Những suy nghĩ thú vị, Trần Thị Bích.', 0),
    (2, 4, 3, 'Cảm ơn bạn đã chia sẻ!', 1),
    (3, 5, NULL, 'Thiết kế tuyệt vời, Lê Văn Cảnh!', 0),
    (3, 6, 5, 'Tôi rất thích nó!', 1),
    (4, 7, NULL, 'Rất nhiều thông tin hữu ích, Phạm Thị Dung.', 0),
    (4, 8, 7, 'Cảm ơn về những hiểu biết sâu sắc.', 1),
    (5, 9, NULL, 'Những thách thức tuyệt vời, Bùi Ngọc Trung.', 0),
    (5, 10, 9, 'Nói hay lắm!', 1),
    (6, 11, NULL, 'Cảm ơn lời khuyên, Hoàng Ngọc Hùng.', 0),
    (6, 12, 11, 'Rất hữu ích.', 1),
    (7, 13, NULL, 'Cuộc thảo luận quan trọng, Hoàng Ngọc Huyền.', 0),
    (7, 14, 13, 'Tôi đồng ý với quan điểm của bạn.', 1),
    (8, 15, NULL, 'Những trải nghiệm tuyệt vời, Phạm Văn Tiến.', 0),
    (8, 1, 15, 'Cảm ơn bạn đã chia sẻ.', 1),
    (9, 2, NULL, 'Chăm sóc sức khỏe rất quan trọng, Lê Quang Hùng.', 0),
    (9, 3, 2, 'Hoàn toàn đúng vậy.', 1),
    (10, 4, NULL, 'Những hiểu biết kỹ thuật thú vị, Nguyễn Trung Dũng.', 0),
    (10, 5, 4, 'Cảm ơn về thông tin.', 1),
    (11, 6, NULL, 'Những mẹo lập trình tuyệt vời, Nguyễn Hoàng Dương.', 0),
    (11, 7, 6, 'Rất hữu dụng.', 1),
    (12, 8, NULL, 'Ngân hàng rất quan trọng, Bùi Thị Hạnh.', 0),
    (12, 9, 8, 'Đúng vậy.', 1),
    (13, 10, NULL, 'Lời khuyên tài chính rất có giá trị, Hoàng Ngọc Huyền.', 0),
    (13, 11, 10, 'Cảm ơn bạn đã chia sẻ.', 1),
    (14, 12, NULL, 'Giáo dục là chìa khóa, Trương Minh Hùng.', 0),
    (14, 13, 12, 'Hoàn toàn đồng ý.', 1),
    (15, 14, NULL, 'Những hiểu biết về phát triển phần mềm tuyệt vời, Nguyễn Quang Thịnh.', 0),
    (15, 15, 14, 'Rất nhiều thông tin bổ ích.', 1);