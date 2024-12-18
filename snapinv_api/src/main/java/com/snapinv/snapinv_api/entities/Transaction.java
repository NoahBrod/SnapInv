package com.snapinv.snapinv_api.entities;

import java.sql.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "Transactions")
public class Transaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String logType;
    private String logBody;
    private Date date;

    public Transaction(String logType, String logBody, Date date) {
        this.logType = logType;
        this.logBody = logBody;
        this.date = date;
    }    

    public Transaction() {
    }

    public Long getId() {
        return this.id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getLogType() {
        return this.logType;
    }

    public void setLogType(String logType) {
        this.logType = logType;
    }

    public String getLogBody() {
        return this.logBody;
    }

    public void setLogBody(String logBody) {
        this.logBody = logBody;
    }

    public Date getDate() {
        return this.date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    @Override
    public String toString() {
        return "{" +
            " id='" + getId() + "'" +
            ", logType='" + getLogType() + "'" +
            ", logBody='" + getLogBody() + "'" +
            ", date='" + getDate() + "'" +
            "}";
    }
}
