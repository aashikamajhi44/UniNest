package model;

import java.sql.Timestamp;

public class Roommate {

    private int       id;
    private int       senderId;
    private int       receiverId;
    private int       propertyId;
    private String    status;          // pending | accepted | rejected
    private Timestamp createdAt;

    // joined fields
    private String    senderName;
    private String    receiverName;
    private String    senderEmail;
    private String    receiverEmail;
    private String    propertyTitle;

    public Roommate() {}

    // ---- Getters & Setters ----

    public int       getId()                          { return id; }
    public void      setId(int id)                    { this.id = id; }

    public int       getSenderId()                    { return senderId; }
    public void      setSenderId(int id)              { this.senderId = id; }

    public int       getReceiverId()                  { return receiverId; }
    public void      setReceiverId(int id)            { this.receiverId = id; }

    public int       getPropertyId()                  { return propertyId; }
    public void      setPropertyId(int id)            { this.propertyId = id; }

    public String    getStatus()                      { return status; }
    public void      setStatus(String s)              { this.status = s; }

    public Timestamp getCreatedAt()                   { return createdAt; }
    public void      setCreatedAt(Timestamp t)        { this.createdAt = t; }

    public String    getSenderName()                  { return senderName; }
    public void      setSenderName(String n)          { this.senderName = n; }

    public String    getReceiverName()                { return receiverName; }
    public void      setReceiverName(String n)        { this.receiverName = n; }

    public String    getSenderEmail()                 { return senderEmail; }
    public void      setSenderEmail(String e)         { this.senderEmail = e; }

    public String    getReceiverEmail()               { return receiverEmail; }
    public void      setReceiverEmail(String e)       { this.receiverEmail = e; }

    public String    getPropertyTitle()               { return propertyTitle; }
    public void      setPropertyTitle(String t)       { this.propertyTitle = t; }
}
