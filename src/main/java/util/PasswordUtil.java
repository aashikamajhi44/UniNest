package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    private static final int SALT_ROUNDS = 12;

    /**
     * Hash a plain-text password using BCrypt.
     */
    public static String hash(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(SALT_ROUNDS));
    }

    /**
     * Verify a plain-text password against a stored BCrypt hash.
     */
    public static boolean verify(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) return false;
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
