package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class UploadServlet extends HttpServlet {

    public static Path getUploadDirectory() {
        return Paths.get(System.getProperty("user.home"), ".uninest", "uploads");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.contains("..")) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String fileName = Paths.get(pathInfo).getFileName().toString();
        Path uploadDirectory = getUploadDirectory();
        Path image = uploadDirectory.resolve(fileName).normalize();
        if (!image.startsWith(uploadDirectory) || !Files.isRegularFile(image)) {
            image = getLegacyUploadPath(fileName);
        }
        if (image == null || !Files.isRegularFile(image)) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = getServletContext().getMimeType(fileName);
        res.setContentType(contentType != null ? contentType : "application/octet-stream");
        res.setContentLengthLong(Files.size(image));
        try (OutputStream out = res.getOutputStream()) {
            Files.copy(image, out);
        }
    }

    private Path getLegacyUploadPath(String fileName) {
        String legacyDirectory = getServletContext().getRealPath("/uploads");
        String legacyPath = getServletContext().getRealPath("/uploads/" + fileName);
        if (legacyDirectory == null || legacyPath == null) {
            return null;
        }

        Path legacyUploadDirectory = Paths.get(legacyDirectory).normalize();
        Path image = Paths.get(legacyPath).normalize();
        return image.startsWith(legacyUploadDirectory) ? image : null;
    }
}
