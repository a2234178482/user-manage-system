CREATE DATABASE IF NOT EXISTS usermanage DEFAULT CHARSET=utf8;

USE usermanage;

DROP TABLE IF EXISTS role_permission;
DROP TABLE IF EXISTS permission;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS user;

CREATE TABLE role (
    id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(200),
    parent_id INT DEFAULT NULL,
    FOREIGN KEY (parent_id) REFERENCES role(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE permission (
    id INT PRIMARY KEY AUTO_INCREMENT,
    permission_name VARCHAR(100) NOT NULL UNIQUE,
    resource VARCHAR(100) NOT NULL,
    action VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE role_permission (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES role(id),
    FOREIGN KEY (permission_id) REFERENCES permission(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(64) NOT NULL,
    salt VARCHAR(32) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role_id INT DEFAULT 2,
    login_attempts INT DEFAULT 0,
    is_locked TINYINT DEFAULT 0,
    lock_time DATETIME DEFAULT NULL,
    FOREIGN KEY (role_id) REFERENCES role(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO role (role_name, description, parent_id) VALUES ('admin', '系统管理员，拥有全部权限', NULL);
INSERT INTO role (role_name, description, parent_id) VALUES ('user', '普通用户，拥有基本权限', NULL);
INSERT INTO role (role_name, description, parent_id) VALUES ('editor', '编辑员，可管理内容', 2);

INSERT INTO permission (permission_name, resource, action) VALUES ('user_view', 'user', 'view');
INSERT INTO permission (permission_name, resource, action) VALUES ('user_add', 'user', 'add');
INSERT INTO permission (permission_name, resource, action) VALUES ('user_edit', 'user', 'edit');
INSERT INTO permission (permission_name, resource, action) VALUES ('user_delete', 'user', 'delete');
INSERT INTO permission (permission_name, resource, action) VALUES ('role_manage', 'role', 'manage');
INSERT INTO permission (permission_name, resource, action) VALUES ('system_admin', 'system', 'admin');

INSERT INTO role_permission (role_id, permission_id) VALUES (1, 1);
INSERT INTO role_permission (role_id, permission_id) VALUES (1, 2);
INSERT INTO role_permission (role_id, permission_id) VALUES (1, 3);
INSERT INTO role_permission (role_id, permission_id) VALUES (1, 4);
INSERT INTO role_permission (role_id, permission_id) VALUES (1, 5);
INSERT INTO role_permission (role_id, permission_id) VALUES (1, 6);

INSERT INTO role_permission (role_id, permission_id) VALUES (2, 1);
INSERT INTO role_permission (role_id, permission_id) VALUES (2, 2);
INSERT INTO role_permission (role_id, permission_id) VALUES (2, 3);

INSERT INTO role_permission (role_id, permission_id) VALUES (3, 1);
INSERT INTO role_permission (role_id, permission_id) VALUES (3, 2);
INSERT INTO role_permission (role_id, permission_id) VALUES (3, 3);
INSERT INTO role_permission (role_id, permission_id) VALUES (3, 4);

INSERT INTO user (username, password, salt, email, role_id) VALUES ('admin', 'placeholder', 'placeholder', 'admin@example.com', 1);
INSERT INTO user (username, password, salt, email, role_id) VALUES ('zhangsan', 'placeholder', 'placeholder', 'zhangsan@example.com', 2);
INSERT INTO user (username, password, salt, email, role_id) VALUES ('lisi', 'placeholder', 'placeholder', 'lisi@example.com', 3);
INSERT INTO user (username, password, salt, email, role_id) VALUES ('wangwu', 'placeholder', 'placeholder', 'wangwu@example.com', 2);
