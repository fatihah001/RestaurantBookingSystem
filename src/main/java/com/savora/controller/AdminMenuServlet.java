package com.savora.controller;

import com.savora.dao.MenuDAO;
import com.savora.model.MenuItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "AdminMenuServlet", urlPatterns = { "/admin/menu" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 15)
public class AdminMenuServlet extends HttpServlet {

    private final MenuDAO menuDAO = new MenuDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String category = request.getParameter("category");
            List<MenuItem> items = (category != null && !category.equalsIgnoreCase("All"))
                    ? menuDAO.findByCategory(category)
                    : menuDAO.findAll();

            request.setAttribute("menuItems", items);
            request.setAttribute("selectedCategory", category != null ? category : "All");
            request.getRequestDispatcher("/WEB-INF/admin/menu.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Error loading menu: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                handleAddItem(request, response);
            } else if ("edit".equals(action)) {
                handleEditItem(request, response);
            } else if ("delete".equals(action)) {
                handleDeleteItem(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/menu");
            }
        } catch (Exception e) {
            // THIS WILL SHOW THE ERROR MESSAGE IN THE BROWSER
            e.printStackTrace();
            response.setContentType("text/html");
            response.getWriter().println("<h1>Error Processing Request</h1>");
            response.getWriter().println("<p><b>Action:</b> " + action + "</p>");
            response.getWriter().println("<p><b>Error Message:</b> " + e.getMessage() + "</p>");
            response.getWriter().println("<a href='menu'>Go Back</a>");
        }
    }

    private void handleAddItem(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String itemName = request.getParameter("itemName");
        String category = request.getParameter("category");
        String priceStr = request.getParameter("price");
        String description = request.getParameter("description");
        boolean available = request.getParameter("available") != null;

        if (priceStr == null || priceStr.isEmpty())
            throw new Exception("Price is missing");

        BigDecimal price = new BigDecimal(priceStr);
        Part filePart = request.getPart("image");
        String imageUrl = saveUploadedFile(filePart, request);

        if (imageUrl == null || imageUrl.isEmpty()) {
            imageUrl = "assets/images/default.jpg";
        }

        MenuItem item = new MenuItem();
        item.setItemName(itemName);
        item.setCategory(category);
        item.setItemPrice(price);
        item.setDescription(description);
        item.setImageUrl(imageUrl);
        item.setAvailable(available);

        menuDAO.create(item);
        response.sendRedirect(request.getContextPath() + "/admin/menu");
    }

    private void handleEditItem(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String menuIdStr = request.getParameter("menuId");
        if (menuIdStr == null || menuIdStr.isEmpty())
            throw new Exception("Menu ID is missing for Edit");

        int menuId = Integer.parseInt(menuIdStr);
        String itemName = request.getParameter("itemName");
        String category = request.getParameter("category");
        String priceStr = request.getParameter("price");
        String description = request.getParameter("description");
        boolean available = request.getParameter("available") != null;

        MenuItem existingItem = menuDAO.findById(menuId);
        if (existingItem == null)
            throw new Exception("Item not found in Database");

        Part filePart = request.getPart("image");
        String newImageUrl = saveUploadedFile(filePart, request);

        existingItem.setItemName(itemName);
        existingItem.setCategory(category);
        existingItem.setItemPrice(new BigDecimal(priceStr));
        existingItem.setDescription(description);
        existingItem.setAvailable(available);

        if (newImageUrl != null && !newImageUrl.isEmpty()) {
            existingItem.setImageUrl(newImageUrl);
        }

        menuDAO.update(existingItem);
        response.sendRedirect(request.getContextPath() + "/admin/menu");
    }

    private void handleDeleteItem(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int menuId = Integer.parseInt(request.getParameter("menuId"));
        menuDAO.delete(menuId);
        response.sendRedirect(request.getContextPath() + "/admin/menu");
    }

    private String saveUploadedFile(Part part, HttpServletRequest request) throws IOException {
        if (part == null || part.getSize() == 0)
            return null;

        String fileName = part.getSubmittedFileName();
        if (fileName == null || fileName.isEmpty())
            return null;

        fileName = new File(fileName).getName().replaceAll("\\s+", "_");
        String relativePath = "assets/images/" + fileName;

        // Deployed path
        String uploadPath = request.getServletContext().getRealPath("/assets/images");
        if (uploadPath == null) {
            uploadPath = request.getServletContext().getRealPath("/") + "assets/images";
        }

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists())
            uploadDir.mkdirs();

        File depFile = new File(uploadDir, fileName);

        // Write to deployed path using stream to prevent GlassFish appending virtual
        // paths
        try (java.io.InputStream input = part.getInputStream()) {
            Files.copy(input, depFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
        }

        // Copy to source folder for persistence in NetBeans source structure
        String sourcePath = "c:\\xampp\\htdocs\\RestaurantBookingSystem\\src\\main\\webapp\\assets\\images";
        File srcDir = new File(sourcePath);
        if (!srcDir.exists()) {
            srcDir.mkdirs();
        }
        File srcFile = new File(srcDir, fileName);
        try {
            Files.copy(depFile.toPath(), srcFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
        } catch (Exception e) {
            System.err.println("Failed to copy image to source directory: " + e.getMessage());
        }

        return relativePath;
    }
}