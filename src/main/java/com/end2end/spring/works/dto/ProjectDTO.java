package com.end2end.spring.works.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.security.Timestamp;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProjectDTO {

    private int id;
    private String name;
    private String hideYn;
    private String status;
//프로젝트도 진행중과 완료로 상태가 나뉠거니까 필요한것같음
    private Timestamp regDate;
    private Timestamp deadLine;
}
