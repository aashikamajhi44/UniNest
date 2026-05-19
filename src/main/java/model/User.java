package model;

import java.sql.Timestamp;

public class User {

    private int       id;
    private String    name;
    private String    email;
    private String    password;
    private String    phone;
    private String    role;          // "admin" | "landlord" | "student"
    private boolean   isVerified;
    private Timestamp createdAt;

    public User() {}

    public User(int id, String name, String email, String role) {
        this.id    = id;
        this.name  = name;
        this.email = email;
        this.role  = role;
    }

    // ---- Getters & Setters ----

    public int       getId()                     { return id; }
    public void      setId(int id)               { this.id = id; }

    public String    getName()                   { return name; }
    public void      setName(String name)        { this.name = name; }

    public String    getEmail()                  { return email; }
    public void      setEmail(String email)      { this.email = email; }

    public String    getPassword()               { return password; }
    public void      setPassword(String p)       { this.password = p; }

    public String    getPhone()                  { return phone; }
    public void      setPhone(String phone)      { this.phone = phone; }

    public String    getRole()                   { return role; }
    public void      setRole(String role)        { this.role = role; }

    public boolean   isVerified()                { return isVerified; }
    public void      setVerified(boolean v)      { this.isVerified = v; }

    public Timestamp getCreatedAt()              { return createdAt; }
    public void      setCreatedAt(Timestamp t)   { this.createdAt = t; }
}
