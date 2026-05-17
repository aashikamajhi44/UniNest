package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Property {

    private int        id;
    private int        landlordId;
    private String     title;
    private String     description;
    private String     location;
    private BigDecimal price;
    private String     roomType;       // single | shared | studio | apartment
    private String     amenities;
    private String     imageUrl;
    private String     status;         // pending | approved | rejected
    private Timestamp  createdAt;

    // joined field
    private String     landlordName;

    public Property() {}

    // ---- Getters & Setters ----

    public int        getId()                       { return id; }
    public void       setId(int id)                 { this.id = id; }

    public int        getLandlordId()               { return landlordId; }
    public void       setLandlordId(int id)         { this.landlordId = id; }

    public String     getTitle()                    { return title; }
    public void       setTitle(String title)        { this.title = title; }

    public String     getDescription()              { return description; }
    public void       setDescription(String d)      { this.description = d; }

    public String     getLocation()                 { return location; }
    public void       setLocation(String l)         { this.location = l; }

    public BigDecimal getPrice()                    { return price; }
    public void       setPrice(BigDecimal p)        { this.price = p; }

    public String     getRoomType()                 { return roomType; }
    public void       setRoomType(String t)         { this.roomType = t; }

    public String     getAmenities()                { return amenities; }
    public void       setAmenities(String a)        { this.amenities = a; }

    public String     getImageUrl()                 { return imageUrl; }
    public void       setImageUrl(String url)       { this.imageUrl = url; }

    public String     getStatus()                   { return status; }
    public void       setStatus(String s)           { this.status = s; }

    public Timestamp  getCreatedAt()                { return createdAt; }
    public void       setCreatedAt(Timestamp t)     { this.createdAt = t; }

    public String     getLandlordName()             { return landlordName; }
    public void       setLandlordName(String n)     { this.landlordName = n; }
}
