package model;

import dbutil.Dbconn;
import entity.Permission;
import entity.Role;
import entity.User;
import util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class Model {

    private static final int MAX_LOGIN_ATTEMPTS = 5;
    private static final int LOCK_MINUTES = 30;

    public User login(String username, String inputPassword) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        User user = null;
        try {
            conn = Dbconn.getConnection();
            String sql = "SELECT u.*, r.role_name FROM user u LEFT JOIN role r ON u.role_id = r.id WHERE u.username=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                user = mapUser(rs);
                if (user.isLocked()) {
                    String lockTime = user.getLockTime();
                    if (lockTime != null) {
                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        java.util.Date lockedAt = sdf.parse(lockTime);
                        long elapsed = (System.currentTimeMillis() - lockedAt.getTime()) / 60000;
                        if (elapsed >= LOCK_MINUTES) {
                            unlockUser(user.getId());
                            user.setLocked(false);
                            user.setLoginAttempts(0);
                        } else {
                            return null;
                        }
                    } else {
                        return null;
                    }
                }
                if (PasswordUtil.verify(inputPassword, user.getSalt(), user.getPassword())) {
                    resetLoginAttempts(user.getId());
                    user.setLoginAttempts(0);
                } else {
                    incrementLoginAttempts(user.getId(), user.getLoginAttempts());
                    user = null;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return user;
    }

    public boolean insert(User u) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean result = false;
        try {
            conn = Dbconn.getConnection();
            String salt = PasswordUtil.generateSalt();
            String encryptedPwd = PasswordUtil.encrypt(u.getPassword(), salt);
            String sql = "INSERT INTO user (username, password, salt, email, role_id) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, u.getUsername());
            pstmt.setString(2, encryptedPwd);
            pstmt.setString(3, salt);
            pstmt.setString(4, u.getEmail());
            pstmt.setInt(5, u.getRoleId());
            int rows = pstmt.executeUpdate();
            if (rows > 0) result = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, pstmt, conn);
        }
        return result;
    }

    public boolean delete(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean result = false;
        try {
            conn = Dbconn.getConnection();
            String sql = "DELETE FROM user WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            int rows = pstmt.executeUpdate();
            if (rows > 0) result = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, pstmt, conn);
        }
        return result;
    }

    public boolean update(User u) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean result = false;
        try {
            conn = Dbconn.getConnection();
            if (u.getPassword() != null && !u.getPassword().isEmpty()) {
                String salt = PasswordUtil.generateSalt();
                String encryptedPwd = PasswordUtil.encrypt(u.getPassword(), salt);
                String sql = "UPDATE user SET username=?, password=?, salt=?, email=?, role_id=? WHERE id=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, u.getUsername());
                pstmt.setString(2, encryptedPwd);
                pstmt.setString(3, salt);
                pstmt.setString(4, u.getEmail());
                pstmt.setInt(5, u.getRoleId());
                pstmt.setInt(6, u.getId());
            } else {
                String sql = "UPDATE user SET username=?, email=?, role_id=? WHERE id=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, u.getUsername());
                pstmt.setString(2, u.getEmail());
                pstmt.setInt(3, u.getRoleId());
                pstmt.setInt(4, u.getId());
            }
            int rows = pstmt.executeUpdate();
            if (rows > 0) result = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, pstmt, conn);
        }
        return result;
    }

    public User search(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        User user = null;
        try {
            conn = Dbconn.getConnection();
            String sql = "SELECT u.*, r.role_name FROM user u LEFT JOIN role r ON u.role_id = r.id WHERE u.id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                user = mapUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return user;
    }

    public User searchByUsername(String username) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        User user = null;
        try {
            conn = Dbconn.getConnection();
            String sql = "SELECT u.*, r.role_name FROM user u LEFT JOIN role r ON u.role_id = r.id WHERE u.username=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                user = mapUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return user;
    }

    public List<User> showAll() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<User> list = new ArrayList<User>();
        try {
            conn = Dbconn.getConnection();
            String sql = "SELECT u.*, r.role_name FROM user u LEFT JOIN role r ON u.role_id = r.id";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return list;
    }

    public List<Role> showAllRoles() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Role> list = new ArrayList<Role>();
        try {
            conn = Dbconn.getConnection();
            String sql = "SELECT * FROM role";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Role role = new Role();
                role.setId(rs.getInt("id"));
                role.setRoleName(rs.getString("role_name"));
                role.setDescription(rs.getString("description"));
                int parentId = rs.getInt("parent_id");
                role.setParentId(rs.wasNull() ? -1 : parentId);
                list.add(role);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return list;
    }

    public List<Permission> getPermissionsByRoleId(int roleId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Permission> list = new ArrayList<Permission>();
        try {
            conn = Dbconn.getConnection();
            String sql = "SELECT p.* FROM permission p JOIN role_permission rp ON p.id = rp.permission_id WHERE rp.role_id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, roleId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Permission perm = new Permission();
                perm.setId(rs.getInt("id"));
                perm.setPermissionName(rs.getString("permission_name"));
                perm.setResource(rs.getString("resource"));
                perm.setAction(rs.getString("action"));
                list.add(perm);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return list;
    }

    public List<Permission> getAllPermissions() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Permission> list = new ArrayList<Permission>();
        try {
            conn = Dbconn.getConnection();
            String sql = "SELECT * FROM permission";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Permission perm = new Permission();
                perm.setId(rs.getInt("id"));
                perm.setPermissionName(rs.getString("permission_name"));
                perm.setResource(rs.getString("resource"));
                perm.setAction(rs.getString("action"));
                list.add(perm);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return list;
    }

    public boolean hasPermission(int roleId, String resourceName, String actionName) {
        List<Permission> perms = getPermissionsByRoleId(roleId);
        List<Permission> inherited = getInheritedPermissions(roleId);
        perms.addAll(inherited);
        for (Permission p : perms) {
            if (p.getResource().equals(resourceName) && p.getAction().equals(actionName)) {
                return true;
            }
        }
        return false;
    }

    public List<Permission> getInheritedPermissions(int roleId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Permission> list = new ArrayList<Permission>();
        try {
            conn = Dbconn.getConnection();
            String sql = "SELECT p.* FROM permission p " +
                    "JOIN role_permission rp ON p.id = rp.permission_id " +
                    "JOIN role r ON rp.role_id = r.id " +
                    "WHERE r.parent_id = (SELECT parent_id FROM role WHERE id=?) " +
                    "AND r.id = (SELECT parent_id FROM role WHERE id=?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, roleId);
            pstmt.setInt(2, roleId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Permission perm = new Permission();
                perm.setId(rs.getInt("id"));
                perm.setPermissionName(rs.getString("permission_name"));
                perm.setResource(rs.getString("resource"));
                perm.setAction(rs.getString("action"));
                list.add(perm);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, conn);
        }
        return list;
    }

    public boolean updateRolePermission(int roleId, int permissionId, boolean grant) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean result = false;
        try {
            conn = Dbconn.getConnection();
            if (grant) {
                String sql = "INSERT IGNORE INTO role_permission (role_id, permission_id) VALUES (?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, roleId);
                pstmt.setInt(2, permissionId);
            } else {
                String sql = "DELETE FROM role_permission WHERE role_id=? AND permission_id=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, roleId);
                pstmt.setInt(2, permissionId);
            }
            int rows = pstmt.executeUpdate();
            if (rows > 0) result = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, pstmt, conn);
        }
        return result;
    }

    public boolean unlockUser(int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean result = false;
        try {
            conn = Dbconn.getConnection();
            String sql = "UPDATE user SET login_attempts=0, is_locked=0, lock_time=NULL WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            int rows = pstmt.executeUpdate();
            if (rows > 0) result = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, pstmt, conn);
        }
        return result;
    }

    private void incrementLoginAttempts(int userId, int currentAttempts) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = Dbconn.getConnection();
            int newAttempts = currentAttempts + 1;
            if (newAttempts >= MAX_LOGIN_ATTEMPTS) {
                String sql = "UPDATE user SET login_attempts=?, is_locked=1, lock_time=NOW() WHERE id=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, newAttempts);
                pstmt.setInt(2, userId);
            } else {
                String sql = "UPDATE user SET login_attempts=? WHERE id=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, newAttempts);
                pstmt.setInt(2, userId);
            }
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, pstmt, conn);
        }
    }

    private void resetLoginAttempts(int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = Dbconn.getConnection();
            String sql = "UPDATE user SET login_attempts=0, is_locked=0, lock_time=NULL WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(null, pstmt, conn);
        }
    }

    private User mapUser(ResultSet rs) throws Exception {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setSalt(rs.getString("salt"));
        user.setEmail(rs.getString("email"));
        user.setRoleId(rs.getInt("role_id"));
        user.setRoleName(rs.getString("role_name"));
        user.setLoginAttempts(rs.getInt("login_attempts"));
        user.setLocked(rs.getInt("is_locked") == 1);
        user.setLockTime(rs.getString("lock_time"));
        return user;
    }

    private void closeResources(ResultSet rs, PreparedStatement pstmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            Dbconn.closeConnection(conn);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
