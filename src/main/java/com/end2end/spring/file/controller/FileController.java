package com.end2end.spring.file.controller;

import com.end2end.spring.file.service.FileService;
import com.end2end.spring.util.FileUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@RequestMapping("/file")
@Controller
public class FileController {
    @Autowired
    private FileService fileService;

    @ResponseBody
    @RequestMapping("/upload/image")
    public String uploadImage(MultipartFile file) {
        try {
            return FileUtil.uploadImage(file);
        } catch (IOException e) {
            return e.getMessage();
        }
    }

    @ResponseBody
    @RequestMapping("/delete/image")
    public void deleteImage(String path) {
        // TODO: 이미지 지우기
        FileUtil.removeImage(path);
    }

    @RequestMapping("/download")
    public void download(String path, HttpServletResponse response) {
        fileService.download(path, response);
    }
    @ResponseBody
    @RequestMapping("/delete")
    public void delete(String path) {
        fileService.removeByPath(path);
    }
}
