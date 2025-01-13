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

-- Likes table (cập nhật)
CREATE TABLE likes
(
    id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id   INT NOT NULL,
    post_id   INT,
    comment_id INT,
    is_active BOOLEAN  DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (post_id) REFERENCES posts (id),
    FOREIGN KEY (comment_id) REFERENCES comments (id),
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
    is_deleted    BOOLEAN    DEFAULT FALSE,
    created_at    TIMESTAMP  DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (receiver_user_id) REFERENCES users (id),
    FOREIGN KEY (sender_user_id) REFERENCES users (id)
);

-- Thêm các vai trò mặc định (giữ nguyên như cũ)
INSERT INTO roles (role_name)
VALUES ('USER'),
       ('ADMIN');

-- Message Attachments table
CREATE TABLE message_attachments (
                                     id         INT AUTO_INCREMENT PRIMARY KEY,
                                     message_id INT          NOT NULL,
                                     file_url   VARCHAR(255) NOT NULL,
                                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     FOREIGN KEY (message_id) REFERENCES messages (id)
);
-- Thêm dữ liệu mẫu vào bảng users
INSERT INTO users (first_name, last_name, email, profile_picture_url, bio, date_of_birth, gender, occupation, address)
VALUES ('Nguyễn', 'Văn An', 'nguyenvanan@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCWKwjszvv4ozOjdhRfjqSvuyHPZufhU8jRA&s',
        'Lập trình viên phần mềm.', '1990-01-01', 'Nam', 'Lập trình viên', '123 Đường Lê Lợi, Hà Nội'),
       ('Trần', 'Thị Bích', 'tranthibich@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZ1WrCQUxhuhLL7Ia6Y2B5dLuSeFqL-Q7IWw&s',
        'Quản lý dự án.', '1985-05-15', 'Nữ', 'Quản lý dự án', '456 Đường Nguyễn Huệ, TP.HCM'),
       ('Lê', 'Văn Cảnh', 'levancanh@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQv_IDmGi-C7NToRtQwTaww0o5-ccE-sIHH3Q&s',
        'Nhà thiết kế đồ họa.', '1992-08-20', 'Nam', 'Nhà thiết kế đồ họa', '789 Đường Trần Phú, Đà Nẵng'),
       ('Phạm', 'Thị Dung', 'phamthidung@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQB5kMQARDYlPowMhelitMySeksJA9XdfweWg&s',
        'Nhà khoa học dữ liệu.', '1988-12-12', 'Nữ', 'Nhà khoa học dữ liệu', '321 Đường Hùng Vương, Huế'),
       ('Bùi', 'Ngọc Trung', 'ngoctrung@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtkmXzJNuJvLNDIk0yaXDtpVkIoBvKCjhwVg&s', 'Kỹ sư',
        '1988-11-12', 'Nam', 'Kỹ sư', '08 Đường Hùng Vương, Hà Nội'),
       ('Hoàng', 'Ngọc Hưng', 'hung@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVwmE2_xJL7vkWGJiQPIlAlV1vCJIzD8mMbw&s', 'Bác sĩ',
        '1998-12-18', 'Nam', 'Bác sĩ', '252 Đường Trần Phú, Huế'),
       ('Hoàng', 'Ngọc Huyền', 'huyen123@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWk2_S11AyyUHxns_NuaVz-WxoVdy0pujYqw&s', 'Công an',
        '1998-12-02', 'Nữ', 'Công an', '23 Đường Phùng Hưng, Đà Lạt'),
       ('Phạm', 'Văn Tiến', 'vantien122@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV3igkD3BZ0iEeyzZyQBwW9Mjv-eZGmRLiBA&s', 'Giáo viên',
        '1999-12-12', 'Nam', 'Giáo viên', '76 Đường Hùng Vương, Hải Phòng'),
       ('Lê', 'Quang Hùng', 'quanghung121@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTXCsrfJBefSPC8hNkPrfaA-41ECHFUDWUtpA&s', 'Bác sĩ',
        '1991-12-12', 'Nam', 'Bác sĩ', '76 Đường Hùng Vương, Quảng Ninh'),
       ('Nguyễn', 'Trung Dũng', 'trungdung222@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWG3BTZpegdCKYStlDoadA_7MRacvPvvKbOw&s',
        'Kĩ sư xây dựng', '1998-10-12', 'Nam', 'Kĩ sư xây dựng', '176 Đường Hai Bà Trưng, Hải Phòng'),
       ('Nguyễn', 'Hoàng Dương', 'hoangduong222@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT11a65u7tVOZygGTz9XoKGcrzuZZq78CwBfw&s',
        'Lập trình viên', '1998-10-12', 'Nam', 'Lập trình viên', '176 Đường Võ Nguyên Giáp, Bình Dương'),
       ('Bùi', 'Thị Hạnh', 'thihanh112@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0VNeAJTKJ5PvH9Pn7h5W6Rk6ZO1ju8sQ_tQ&s', 'Ngân hàng',
        '1998-4-12', 'Nam', 'Ngân hàng', '144 Đường Hai Bà Trưng, Daklak'),
       ('Hoàng', 'Ngọc Huyền', 'ngochuyen344@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTno3saNJhMbyaArPOvu4vgwhmBankYIBWZKg&s', 'Ngân hàng',
        '1997-10-12', 'Nam', 'Ngân hàng', '42 Trần Phú, Thanh Hoá'),
       ('Trương', 'Minh Hưng', 'minhhung567@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVcC3CvGPeyIvCCZVPPNuw2_uI7Fr_s6QK-Q&s', 'Giáo viên',
        '1988-10-12', 'Nam', 'Giáo viên', '476 Đường Hai Bà Trưng, Nghệ An'),
    ('Nguyễn', 'Quang Thịnh', 'quangthinh@example.com', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGHq9MWK8tFit566FFNdt7YtHX60g5ccTUhg&s', 'Lập trình viên', '1994-10-12', 'Nam', 'Lập trình viên', '176 Đường Hai Bà Trưng, Quảng Bình');
INSERT INTO users (first_name, last_name, email, profile_picture_url, bio, date_of_birth, gender, occupation, address)
VALUES ('Trần', 'Hồng Phúc', '142342@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTtJ1R3JMyJK-5ypd9jA7FbSDyGb5Km8emnQ&s',
        'Lập trình viên phần mềm.', '1990-01-01', 'Nam', 'Lập trình viên', '144 Đường Lê Lợi, Hà Nội'),
       ('Hoàng', 'Vân Anh', 'anh1234245@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSaFne3ZhcpDbFc1hqrdNRtmE4cB8nuLCgGnw&s', 'Ngân hàng',
        '1990-01-03', 'Nữ', 'Ngân hàng', '177 Đường Lê Lợi, Hà Nội'),
       ('Võ', 'Hoài Linh', 'linn11234231@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThl42MwkbB-Fq2892irytLd13Jn4rBi_c2lQ&s',
        'Kĩ sư cầu đường', '1990-11-01', 'Nam', 'Kĩ sư cầu đường', '123 Đường Lê Hồng Phong, Hà Nội'),
       ('Bùi', 'Văn Trung', 'trung23468@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR22Ujota8OXVQ-70XlkKil8ufYE2mivIJ4Gw&s',
        'Kĩ sư xây dựng', '1994-01-01', 'Nam', 'Kĩ sư xây dựng', '123 Đường Lê Lợi, Huế'),
       ('Hồ', 'Thành Trung', 'trung2342345@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGHq9MWK8tFit566FFNdt7YtHX60g5ccTUhg&s',
        'Cầu thủ bóng đá', '1990-01-01', 'Nam', 'Cầu thủ bóng đá', '123 Đường Hai Bà Trưng, Hà Nội'),
       ('Nguyễn', 'Thị Hồng', 'hong22224@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJsUXVw598oXoJnJZ4_3UMXxKWKce6T3tO-g&s', 'Giáo viên',
        '1990-01-01', 'Nữ', 'Giáo viên', '123 Đường Lê Lợi, Hà Tĩnh');

INSERT INTO users (first_name, last_name, email, profile_picture_url, bio, date_of_birth, gender, occupation, address)
VALUES ('Lý', 'Nam Trực', 'truc223422@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZOt5y65YnvXq3nQRSj5TxsqtZKsz9ChIn1Q&s',
        'Sĩ quan quân đội', '1993-01-01', 'Nam', 'Sĩ quan quân đội', '123 Đường Nam Kì Khởi Nghĩa, Sài Gòn'),
       ('Hoàng', 'Thái Văn', 'van023400@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRaUR0sJmtEF3m_sG4OtXtVtpGlkLEJT3KEnQ&s',
        'Lập trình viên phần mềm.', '1990-01-01', 'Nam', 'Lập trình viên', '121 Đường Lê Lợi, Hà Nội'),
       ('Trần', 'Hạnh Phúc', 'phuc223467@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZ1WrCQUxhuhLL7Ia6Y2B5dLuSeFqL-Q7IWw&s', 'Kế toán',
        '1992-01-01', 'Nữ', 'Kế toán', '1113 Đường Lê Lợi, Hà Nội'),
       ('Nguyễn', 'Hồng Hạnh', 'hanh2234657@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRROsPyTGkI4dZzgsHkrlyV_Swj3g6OR3is5Q&s',
        'Giáo viên tiểu học', '1990-01-21', 'Nữ', 'Giáo viên tiểu học', '123 Đường Lê Lợi, Huế'),
       ('Trần', 'Hồng Toàn', 'phuc123423@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWAp6eSeJPXknK9-PXK3DBsY6D81kQZS3dQA&s',
        'Lập trình viên phần mềm.', '1990-01-01', 'Nam', 'Lập trình viên', '144 Đường Lê Lợi, Hà Nội'),
       ('Hoàng', 'Anh Tuấn', 'anh12323445@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo8K13qx5-wlX_1jP3oYdASuqldzmJ8HEZsw&s', 'Ngân hàng',
        '1990-01-03', 'Nữ', 'Ngân hàng', '177 Đường Lê Lợi, Hà Nội'),
       ('Võ', 'Hoài Long', 'linn123411@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjOL9aOHr4QrwR1jMBEJIcR_oZZ8Kfu-N3iw&s',
        'Kĩ sư cầu đường', '1990-11-01', 'Nam', 'Kĩ sư cầu đường', '123 Đường Lê Hồng Phong, Hà Nội'),
       ('Bùi', 'Trọng Nghĩa', 'trung62438@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGHq9MWK8tFit566FFNdt7YtHX60g5ccTUhg&s',
        'Kĩ sư xây dựng', '1994-01-01', 'Nam', 'Kĩ sư xây dựng', '123 Đường Lê Lợi, Huế');

INSERT INTO users (first_name, last_name, email, profile_picture_url, bio, date_of_birth, gender, occupation, address)
VALUES ('Hồ', 'Thành Nhân', 'trung2323234445@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbWTaHzJomyvIyp16VSADiG-lFnjhHW--nvw&s',
        'Cầu thủ bóng đá', '1990-01-01', 'Nam', 'Cầu thủ bóng đá', '123 Đường Hai Bà Trưng, Hà Nội'),
       ('Nguyễn', 'Thị Hồng', 'hong223423422@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTK9r_oL44eycjnbUER4_Aj__5PhtGN-YL4KQ&s', 'Giáo viên',
        '1990-01-01', 'Nữ', 'Giáo viên', '123 Đường Lê Lợi, Hà Tĩnh'),
       ('Lý', 'Thái Thông', 'truc222234342@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTMqcCXSPd1GayrYoUaN2o4vaBaiZCOa7v7Q&s',
        'Sĩ quan quân đội', '1993-01-01', 'Nam', 'Sĩ quan quân đội', '123 Đường Nam Kì Khởi Nghĩa, Sài Gòn'),
       ('Hoàng', 'Văn Thụ', 'van000223443@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSi0atcxH8f31ejNv2y26aTZj1ZZdK-wqLu7g&s',
        'Lập trình viên phần mềm.', '1990-01-01', 'Nam', 'Lập trình viên', '121 Đường Lê Lợi, Hà Nội'),
       ('Trần', 'Vĩnh Khoa', 'phuc223423467@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR79o_QpWvkIAthQHkpNQGG_Qz8m1VuapE5Dg&s', 'Kế toán',
        '1992-01-01', 'Nữ', 'Kế toán', '1113 Đường Lê Lợi, Hà Nội'),
       ('Nguyễn', 'Hải Hiếu', 'hanh622343457@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcLm_DoM7fZHBCHzHESPxlKmWjByV6sRkqpA&s',
        'Giáo viên tiểu học', '1990-01-21', 'Nữ', 'Giáo viên tiểu học', '123 Đường Lê Lợi, Huế'),
       ('Trần', 'THị Loan', 'phuc12322344@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2XNTUSJXct4lHPb0On2G6_NDcrevTu9EPRQ&s',
        'Lập trình viên phần mềm.', '1990-01-01', 'Nam', 'Lập trình viên', '144 Đường Lê Lợi, Hà Nội');

INSERT INTO users (first_name, last_name, email, profile_picture_url, bio, date_of_birth, gender, occupation, address)
VALUES ('Hoàng', 'Vân Dung', 'anh12342323445@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjSR1uDsHPw7hUk1iwqi7FZtXrEBzWXZ_BsQ&s', 'Ngân hàng',
        '1990-01-03', 'Nữ', 'Ngân hàng', '177 Đường Lê Lợi, Hà Nội'),
       ('Võ', 'Như Thoa', 'linn123234411@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnfo08B-iaZIiDXU9wJ9qyHSaUFsattlukxg&s',
        'Kĩ sư cầu đường', '1990-11-01', 'Nam', 'Kĩ sư cầu đường', '123 Đường Lê Hồng Phong, Hà Nội'),
       ('Bùi', 'Thị Minh Ân', 'trung68234234@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXqMv4lHXdeeMiha1KWS5a_4D8FNvG82pKXw&s',
        'Kĩ sư xây dựng', '1994-01-01', 'Nam', 'Kĩ sư xây dựng', '123 Đường Lê Lợi, Huế'),
       ('Hồ', 'Thị Anh Loan', 'trung2322343445@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZbMPqYroYd4Hmfi_qj2Sxb4v7YBZeL6U07w&s',
        'Cầu thủ bóng đá', '1990-01-01', 'Nam', 'Cầu thủ bóng đá', '123 Đường Hai Bà Trưng, Hà Nội');

INSERT INTO users (first_name, last_name, email, profile_picture_url, bio, date_of_birth, gender, occupation, address)
VALUES ('Nguyễn', 'Thị Hạnh Phúc', 'hong2222134342@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwjcOgAlgElvL7sw_tOFtXrOzO6jowSc_P9Q&s', 'Giáo viên',
        '1990-01-01', 'Nữ', 'Giáo viên', '123 Đường Lê Lợi, Hà Tĩnh'),
       ('Lý', 'Thị Linh', 'truc223234422@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpQdkgtq3Sbj7Hev4wdF8scD12THYNpDM1xA&s',
        'Sĩ quan quân đội', '1993-01-01', 'Nam', 'Sĩ quan quân đội', '123 Đường Nam Kì Khởi Nghĩa, Sài Gòn'),
       ('Hoàng', 'Thị Hương', 'van002342340@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNaQLx6bSO71b5iD0QXJ_7dRa-ttgWdMXJXQ&s',
        'Lập trình viên phần mềm.', '1990-01-01', 'Nam', 'Lập trình viên', '121 Đường Lê Lợi, Hà Nội'),
       ('Trần', 'Thị Huyền', 'phuc262323447@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIzZv-xMgRA5WCycP2TRNVDxEZDZcQSoXNHw&s', 'Kế toán',
        '1992-01-01', 'Nữ', 'Kế toán', '1113 Đường Lê Lợi, Hà Nội'),
       ('Nguyễn', 'Hồng Hiền', 'hanh652323447@example.com',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqP8co14RNwOc37rb8jXsBjIIDsqsjnmaFWA&s',
        'Giáo viên tiểu học', '1990-01-21', 'Nữ', 'Giáo viên tiểu học', '123 Đường Lê Lợi, Huế');


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
    (25, 'hanh12345', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),

    (26, 'codegym26', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (27, 'codegym27', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (28, 'codegym28', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (29, 'codegym29', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (30, 'codegym30', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (31, 'codegym31', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (32, 'codegym32', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (33, 'codegym33', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (34, 'codegym34', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (35, 'codegym35', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (36, 'codegym36', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (37, 'codegym37', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (38, 'codegym38', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (39, 'codegym39', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (40, 'codegym40', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (41, 'codegym41', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (42, 'codegym42', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (43, 'codegym43', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (44, 'codegym44', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO'),
    (45, 'codegym45', '$2a$10$F/Rsby58L8YR..M20BMwgOWkADJ6APD7qBBfJ0dJROXWeaAxixfaO');
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
    (25, 1),
    (26, 1),
    (27, 1),
    (28, 1),
    (29, 1),
    (30, 1),
    (31, 1),
    (32, 1),
    (33, 1),
    (34, 1),
    (35, 1),

    (36, 1),
    (37, 1),
    (38, 1),
    (39, 1),
    (40, 1),
    (41, 1),
    (42, 1),
    (43, 1),
    (44, 1),
    (45, 1);
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
VALUES (19, 29, TRUE),
       (22, 18, TRUE),
       (23, 31, TRUE),
       (26, 1, TRUE),
       (27, 1, TRUE),
       (28, 1, TRUE),
       (29, 1, TRUE),
       (40, 1, TRUE),
       (41, 1, TRUE),
       (42, 1, TRUE),
       (43, 1, TRUE),
       (44, 1, TRUE);
INSERT INTO friendships (user_id1, user_id2, is_accepted)
VALUES (30, 1, false),
       (31, 1, false),
       (32, 1, false),
       (33, 1, false),
       (34, 1, false),
       (35, 1, false),
       (36, 1, false),
       (37, 1, false),
       (38, 1, TRUE),
       (39, 1, TRUE),
       (40, 8, TRUE),
       (26, 2, TRUE),
       (27, 2, TRUE),
       (28, 2, TRUE),
       (29, 2, TRUE),
       (40, 2, TRUE),
       (41, 2, TRUE),
       (42, 2, TRUE),
       (43, 2, TRUE),
       (44, 2, TRUE);
INSERT INTO friendships (user_id1, user_id2, is_accepted)
VALUES (30, 3, false),
       (31, 3, false),
       (32, 3, false),
       (33, 3, false),
       (34, 4, false),
       (35, 4, false),
       (36, 4, false),
       (37, 4, false),
       (38, 4, TRUE),
       (39, 4, TRUE),
       (40, 4, TRUE),
       (26, 5, TRUE),
       (27, 5, TRUE),
       (28, 5, TRUE),
       (29, 5, TRUE),
       (40, 5, TRUE),
       (41, 5, TRUE),
       (42, 5, TRUE),
       (43, 5, TRUE),
       (44, 5, TRUE);
INSERT INTO friendships (user_id1, user_id2, is_accepted)
VALUES (30, 5, false),
       (31, 5, false),
       (32, 5, false),
       (33, 5, false),
       (34, 5, false),
       (35, 5, false),
       (36, 6, false),
       (37, 6, false),
       (38, 6, TRUE),
       (39, 6, TRUE),
       (40, 6, TRUE),
       (26, 7, TRUE),
       (27, 7, TRUE),
       (28, 8, TRUE),
       (29, 8, TRUE),
       (40, 15, TRUE),
       (41, 8, TRUE),
       (42, 7, TRUE),
       (43, 7, TRUE),
       (44, 8, TRUE);
INSERT INTO friendships (user_id1, user_id2, is_accepted)
VALUES (30, 7, false),
       (31, 7, false),
       (32, 7, false),
       (33, 7, false),
       (34, 8, false),
       (35, 8, false),
       (36, 8, false),
       (37, 8, false),
       (38, 7, TRUE),
       (39, 8, TRUE);

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
    (15, 'Nguyễn Quang Thịnh chia sẻ hiểu biết về phát triển phần mềm.'),
    (1, 'Hôm nay tôi học được một kỹ năng mới về lập trình. Rất thú vị!'),
    (1, 'Chia sẻ một số mẹo về cách quản lý thời gian hiệu quả.'),
    (1, 'Đang đọc một cuốn sách hay về AI, ai muốn thảo luận không?'),
    (1, 'Vừa hoàn thành một dự án lớn. Cảm thấy rất tự hào!'),
    (2, 'Chia sẻ kinh nghiệm làm việc nhóm trong các dự án lớn.'),
    (2, 'Những thách thức khi quản lý dự án phần mềm và cách giải quyết.'),
    (2, 'Tầm quan trọng của giao tiếp trong quản lý dự án.'),
    (2, 'Các công cụ quản lý dự án hiệu quả mà tôi hay sử dụng.'),
    (3, 'Xu hướng thiết kế đồ họa mới nhất năm 2023.'),
    (3, 'Cách tạo ra một logo ấn tượng cho doanh nghiệp.'),
    (3, 'Chia sẻ một số tác phẩm thiết kế mới của tôi.'),
    (3, 'Làm thế nào để phát triển phong cách thiết kế cá nhân?'),
    (4, 'Các ứng dụng của AI trong phân tích dữ liệu.'),
    (4, 'Big Data và những thách thức trong việc xử lý.'),
    (4, 'Tầm quan trọng của việc bảo mật dữ liệu trong thời đại số.'),
    (4, 'Machine Learning: Từ lý thuyết đến thực hành.'),
    (5, 'Những xu hướng công nghệ mới trong lĩnh vực kỹ thuật.'),
    (5, 'Cách áp dụng IoT trong các dự án kỹ thuật.'),
    (5, 'Thách thức và giải pháp trong việc tối ưu hóa quy trình sản xuất.'),
    (5, 'Chia sẻ kinh nghiệm làm việc với các dự án kỹ thuật phức tạp.'),
    (1, 'Hôm nay là một ngày tuyệt vời!'),
    (2, 'Vừa hoàn thành một dự án lớn. Cảm thấy rất tự hào!'),
    (3, 'Chia sẻ một số hình ảnh từ chuyến du lịch gần đây của tôi.'),
    (4, 'Đang học một kỹ năng mới. Rất thú vị!'),
    (5, 'Cuối tuần này có ai muốn đi xem phim không?');


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
    (15, 15, 14, 'Rất nhiều thông tin bổ ích.', 1),
    (1, 2, NULL, 'Bài viết hay quá, Nguyễn Văn An! 👍', 0),
    (1, 3, 1, 'Tôi đồng ý với bạn, Trần Thị Bích. 😊', 1),
    (2, 1, NULL, 'Những suy nghĩ thú vị, Trần Thị Bích. 🤔', 0),
    (2, 4, 3, 'Cảm ơn bạn đã chia sẻ! 🙏', 1),
    (3, 5, NULL, 'Thiết kế tuyệt vời, Lê Văn Cảnh! 🎨', 0),
    (3, 6, 5, 'Tôi rất thích nó! 😍', 1),
    (4, 7, NULL, 'Rất nhiều thông tin hữu ích, Phạm Thị Dung. 📊', 0),
    (4, 8, 7, 'Cảm ơn về những hiểu biết sâu sắc. 🧠', 1),
    (5, 9, NULL, 'Những thách thức tuyệt vời, Bùi Ngọc Trung. 💪', 0),
    (5, 10, 9, 'Nói hay lắm! 👏', 1),
    (6, 11, NULL, 'Cảm ơn lời khuyên, Hoàng Ngọc Hùng. 🩺', 0),
    (6, 12, 11, 'Rất hữu ích. 👌', 1),
    (7, 13, NULL, 'Cuộc thảo luận quan trọng, Hoàng Ngọc Huyền. ⚖️', 0),
    (7, 14, 13, 'Tôi đồng ý với quan điểm của bạn. 🤝', 1),
    (8, 15, NULL, 'Những trải nghiệm tuyệt vời, Phạm Văn Tiến. 📚', 0),
    (8, 1, 15, 'Cảm ơn bạn đã chia sẻ. 🙌', 1),
    (9, 2, NULL, 'Chăm sóc sức khỏe rất quan trọng, Lê Quang Hùng. 💓', 0),
    (9, 3, 2, 'Hoàn toàn đúng vậy. 💯', 1),
    (10, 4, NULL, 'Những hiểu biết kỹ thuật thú vị, Nguyễn Trung Dũng. 🔧', 0),
    (10, 5, 4, 'Cảm ơn về thông tin. 🔍', 1),
    (11, 6, NULL, 'Những mẹo lập trình tuyệt vời, Nguyễn Hoàng Dương. 💻', 0),
    (11, 7, 6, 'Rất hữu dụng. 🚀', 1),
    (12, 8, NULL, 'Ngân hàng rất quan trọng, Bùi Thị Hạnh. 💰', 0),
    (12, 9, 8, 'Đúng vậy. 💼', 1),
    (13, 10, NULL, 'Lời khuyên tài chính rất có giá trị, Hoàng Ngọc Huyền. 📈', 0),
    (13, 11, 10, 'Cảm ơn bạn đã chia sẻ. 🙏', 1),
    (14, 12, NULL, 'Giáo dục là chìa khóa, Trương Minh Hùng. 🔑', 0),
    (14, 13, 12, 'Hoàn toàn đồng ý! 👨‍🏫', 1),
    (15, 14, NULL, 'Phát triển phần mềm thật thú vị, Nguyễn Quang Thịnh. 🖥️', 0),
    (15, 15, 14, 'Cảm ơn về những chia sẻ hữu ích. 👨‍💻', 1);
INSERT INTO attachments (post_id, file_url, file_name, file_type, file_size)
VALUES
    (1, 'https://images2.thanhnien.vn/528068263637045248/2024/1/25/e093e9cfc9027d6a142358d24d2ee350-65a11ac2af785880-17061562929701875684912.jpg', 'sunny_day.jpg', 'image/jpeg', 1024000),
    (2, 'https://media.zim.vn/637b3f0f62e55bf01005680c/bai-mau-describe-a-time-when-you-felt-proud-of-a-family-member.jpg', 'project_summary.pdf', 'application/pdf', 2048000),
    (3, 'https://i.insider.com/669864ca80d4d5da13d4cc75?width=700', 'vacation_photo1.jpg', 'image/jpeg', 1536000),
    (3, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStuH5Gx1E99oXDCgvbpIA3ndin8Guaalklmw&s', 'vacation_photo2.jpg', 'image/jpeg', 1792000),
    (3, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJBSchnKLVquh1_Xd4PAovbphvQDifzqmYsg&s', 'vacation_photo3.jpg', 'image/jpeg', 2048000),
    (4, 'https://firebasestorage.googleapis.com/v0/b/familiar-c17d5.firebasestorage.app/o/ROSE%20%26%20Bruno%20Mars%20-%20APT.%20(Official%20Music%20Video).mp4?alt=media&token=a9154d32-d695-4668-a36a-50e3fa7b6baf', 'learning_progress.mp4', 'video/mp4', 10240000),
    (5, 'https://time.ly/wp-content/uploads/2023/03/attract-tourists-destinations.jpg', 'movie_poster.jpg', 'image/jpeg', 512000);


-- Thêm dữ liệu mẫu vào bảng messages
INSERT INTO messages (sender_user_id, receiver_user_id, content, message_type, is_deleted, created_at, updated_at)
VALUES
(1, 2, 'Xin chào! Bạn khỏe không?', 'TEXT', FALSE, '2023-06-01 10:00:00', '2023-06-01 10:00:00'),
(2, 1, 'Chào bạn! Tôi khỏe, còn bạn?', 'TEXT', FALSE, '2023-06-01 10:05:00', '2023-06-01 10:05:00'),
(1, 2, 'Tôi cũng khỏe. Cảm ơn bạn!', 'TEXT', FALSE, '2023-06-01 10:10:00', '2023-06-01 10:10:00'),
(3, 4, 'Bạn có rảnh không? Tôi cần hỏi về dự án.', 'TEXT', FALSE, '2023-06-02 14:30:00', '2023-06-02 14:30:00'),
(4, 3, 'Tôi đang bận một chút. Có gì gấp không?', 'TEXT', FALSE, '2023-06-02 14:35:00', '2023-06-02 14:35:00'),
(3, 4, 'Không gấp lắm. Khi nào rảnh bạn nhắn lại nhé.', 'TEXT', FALSE, '2023-06-02 14:40:00', '2023-06-02 14:40:00'),
(5, 6, 'Chào bạn! Tôi là Ngọc Trung.', 'TEXT', FALSE, '2023-06-03 09:00:00', '2023-06-03 09:00:00'),
(6, 5, 'Chào Trung! Rất vui được làm quen.', 'TEXT', FALSE, '2023-06-03 09:05:00', '2023-06-03 09:05:00'),
(7, 8, 'Bạn có tham gia sự kiện tối nay không?', 'TEXT', FALSE, '2023-06-04 18:00:00', '2023-06-04 18:00:00'),
(8, 7, 'Có, tôi sẽ đến. Gặp bạn ở đó nhé!', 'TEXT', FALSE, '2023-06-04 18:05:00', '2023-06-04 18:05:00');



