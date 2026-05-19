package model;

import java.sql.Timestamp;

/** A student's saved property. Joined with property fields for listing pages. */
public class Wishlist {
    private int id;
    private int studentId;
    private int propertyId;
    private Timestamp createdAt;

    // Joined property fields (populated when listing)
    private String propertyTitle;
    private String propertyLocation;
    private java.math.BigDecimal propertyPrice;
    private String propertyImageUrl;
    private String propertyRoomType;
    private String propertyStatus;
    private String landlordName;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public int getPropertyId() { return propertyId; }
    public void setPropertyId(int propertyId) { this.propertyId = propertyId; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getPropertyTitle() { return propertyTitle; }
    public void setPropertyTitle(String s) { this.propertyTitle = s; }
    public String getPropertyLocation() { return propertyLocation; }
    public void setPropertyLocation(String s) { this.propertyLocation = s; }
    public java.math.BigDecimal getPropertyPrice() { return propertyPrice; }
    public void setPropertyPrice(java.math.BigDecimal p) { this.propertyPrice = p; }
    public String getPropertyImageUrl() { return propertyImageUrl; }
    public void setPropertyImageUrl(String s) { this.propertyImageUrl = s; }
    public String getPropertyRoomType() { return propertyRoomType; }
    public void setPropertyRoomType(String s) { this.propertyRoomType = s; }
    public String getPropertyStatus() { return propertyStatus; }
    public void setPropertyStatus(String s) { this.propertyStatus = s; }
    public String getLandlordName() { return landlordName; }
    public void setLandlordName(String s) { this.landlordName = s; }
}
