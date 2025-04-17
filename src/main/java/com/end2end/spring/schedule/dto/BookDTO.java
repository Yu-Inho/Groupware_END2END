package com.end2end.spring.schedule.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.sql.Timestamp;

@Data
@AllArgsConstructor
public class BookDTO {
    private int id;
    private String employeeId;

    private int targetId;
    private String targetType;
    private String targetName;

    private Timestamp startDate;
    private Timestamp endDate;
    private Timestamp regDate;
}
