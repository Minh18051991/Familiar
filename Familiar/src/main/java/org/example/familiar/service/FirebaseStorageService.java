package org.example.familiar.service;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import java.io.IOException;

@Service
public class FirebaseStorageService {

    @Value("${firebase.bucket-name}")
    private String bucketName;

    @Value("${firebase.config-file}")
    private String firebaseConfigPath;

    private Storage storage;

    @PostConstruct
    private void initializeFirebase() throws IOException {
        GoogleCredentials credentials = GoogleCredentials.fromStream(new ClassPathResource(firebaseConfigPath).getInputStream());
        storage = StorageOptions.newBuilder().setCredentials(credentials).build().getService();
    }

    public String uploadFile(MultipartFile file) throws IOException {
        String fileName = generateFileName(file.getOriginalFilename());
        BlobId blobId = BlobId.of(bucketName, fileName);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType(file.getContentType()).build();
        Blob blob = storage.create(blobInfo, file.getInputStream());
        return blob.getMediaLink();
    }

    private String generateFileName(String originalFileName) {
        return System.currentTimeMillis() + "_" + originalFileName.replaceAll("\\s+", "_");
    }

    public void deleteFile(String fileUrl) {
        String fileName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
        BlobId blobId = BlobId.of(bucketName, fileName);
        storage.delete(blobId);
    }
}