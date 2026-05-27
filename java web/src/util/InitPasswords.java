package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class InitPasswords {

    public static void main(String[] args) throws Exception {
        String url = "jdbc:mysql://localhost:3306/usermanage?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPass = "2234178482";

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, dbUser, dbPass);

        String query = "SELECT id, username FROM user";
        PreparedStatement pstmt = conn.prepareStatement(query);
        ResultSet rs = pstmt.executeQuery();

        String defaultPasswords[] = {"admin123", "zhangsan123", "lisi123", "wangwu123"};
        int index = 0;

        String updateSql = "UPDATE user SET password=?, salt=? WHERE id=?";
        PreparedStatement updateStmt = conn.prepareStatement(updateSql);

        while (rs.next()) {
            int id = rs.getInt("id");
            String salt = PasswordUtil.generateSalt();
            String password = defaultPasswords[index % defaultPasswords.length];
            String encrypted = PasswordUtil.encrypt(password, salt);
            updateStmt.setString(1, encrypted);
            updateStmt.setString(2, salt);
            updateStmt.setInt(3, id);
            updateStmt.executeUpdate();
            System.out.println("User: " + rs.getString("username") + " | Password: " + password + " | Salt: " + salt);
            index++;
        }

        rs.close();
        pstmt.close();
        updateStmt.close();
        conn.close();
        System.out.println("All passwords initialized successfully!");
    }
}
