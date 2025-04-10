package com.end2end.spring.commute.service;

import com.end2end.spring.commute.dto.VacationDTO;
import com.end2end.spring.commute.dto.VacationManagementDTO;

import java.util.List;

public interface VacationService {
    List<VacationDTO> selectByEmployeeId(String employeeId);
    void insert(VacationDTO dto);
    void insertUsableVacation(VacationManagementDTO dto);
    double sumTotalVacationDates(String employeeId);
    double sumTotalUsedVacationDates(String employeeId);
    double sumThisMonthUsedVacationDates(String employeeId);
}
