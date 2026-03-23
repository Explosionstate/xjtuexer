package com.example.mybatisplusdemo.web.controller;

import com.example.mybatisplusdemo.common.JsonResponse;
import com.example.mybatisplusdemo.model.domain.OnlineCourse;
import com.example.mybatisplusdemo.service.IOnlineCourseService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@RestController
@RequestMapping("/api/online-course")
public class OnlineCourseController {
    private static final Logger logger = LoggerFactory.getLogger(OnlineCourseController.class);
    private static final String DEFAULT_VIDEO_PATH = "D:/xjtu/xjtuexer/file/video";

    @Autowired
    private IOnlineCourseService onlineCourseService;

    @GetMapping("/courses")
    public JsonResponse getAllCourses() {
        logger.info("Fetching all courses");
        List<OnlineCourse> courses = onlineCourseService.getAllCourses();
        return JsonResponse.success(courses);
    }

    @PostMapping("/increment-visit")
    public JsonResponse incrementVisitCount(@RequestParam("coursename") String coursename) {
        logger.info("Incrementing visit count for course: {}", coursename);
        onlineCourseService.incrementVisitCount(coursename);
        return JsonResponse.success("Visit count incremented");
    }

    @GetMapping("/video/{filename}")
    public ResponseEntity<Resource> getVideo(@PathVariable String filename) {
        logger.info("Requested video: {}", filename);
        if (!filename.matches("^[a-zA-Z0-9._-]+\\.mp4$")) {
            logger.warn("Invalid video filename requested: {}", filename);
            return ResponseEntity.badRequest().build();
        }

        Path basePath = resolveVideoBasePath();
        Path fullPath = basePath.resolve(filename).normalize();
        if (!fullPath.startsWith(basePath)) {
            logger.warn("Rejected path traversal filename: {}", filename);
            return ResponseEntity.badRequest().build();
        }

        File file = fullPath.toFile();
        logger.info("Attempting to load video file: {}", file.getAbsolutePath());
        if (!file.exists() || !file.isFile()) {
            logger.error("Video file not found or is not a file: {}", file.getAbsolutePath());
            return ResponseEntity.notFound().build();
        }

        Resource resource = new FileSystemResource(file);
        long contentLength = file.length();

        logger.info("Serving full video file: {}", file.getAbsolutePath());
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType("video/mp4"))
                .header("Accept-Ranges", "bytes")
                .header("Content-Length", String.valueOf(contentLength))
                .body(resource);
    }

    private Path resolveVideoBasePath() {
        String configured = System.getenv("ONLINE_VIDEO_PATH");
        if (configured == null || configured.trim().isEmpty()) {
            configured = DEFAULT_VIDEO_PATH;
        }
        return Paths.get(configured).toAbsolutePath().normalize();
    }
}
