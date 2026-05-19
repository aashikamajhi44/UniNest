package model;

import java.sql.Timestamp;

public class Booking {

    private int       id;
    private int       studentId;
    private int       propertyId;
    private String    message;
    private String    status;          // pending | accepted | rejected
    private Timestamp createdAt;

    // joined fields
    private String    studentName;
    private String    propertyTitle;
    private String    propertyLocation;
    private boolean   reviewed;
    private int       reviewRating;
    private String    reviewComment;

    public Booking() {}

    // ---- Getters & Setters ----

    public int       getId()                          { return id; }
    public void      setId(int id)                    { this.id = id; }

    public int       getStudentId()                   { return studentId; }
    public void      setStudentId(int id)             { this.studentId = id; }

    public int       getPropertyId()                  { return propertyId; }
    public void      setPropertyId(int id)            { this.propertyId = id; }

    public String    getMessage()                     { return message; }
    public void      setMessage(String m)             { this.message = m; }

    public String    getStatus()                      { return status; }
    public void      setStatus(String s)              { this.status = s; }

    public Timestamp getCreatedAt()                   { return createdAt; }
    public void      setCreatedAt(Timestamp t)        { this.createdAt = t; }

    public String    getStudentName()                 { return studentName; }
    public void      setStudentName(String n)         { this.studentName = n; }

    public String    getPropertyTitle()               { return propertyTitle; }
    public void      setPropertyTitle(String t)       { this.propertyTitle = t; }

    public String    getPropertyLocation()            { return propertyLocation; }
    public void      setPropertyLocation(String l)    { this.propertyLocation = l; }

    public boolean   isReviewed()                     { return reviewed; }
    public void      setReviewed(boolean reviewed)    { this.reviewed = reviewed; }

    public int       getReviewRating()                { return reviewRating; }
    public void      setReviewRating(int rating)      { this.reviewRating = rating; }

    public String    getReviewComment()               { return reviewComment; }
    public void      setReviewComment(String comment) { this.reviewComment = comment; }
}
