package com.mclaunch.launcher;

import java.io.File;
import java.util.UUID;

/**
 * Manages user profiles for the launcher
 * Similar to PojavLauncher's profile system
 */
public class ProfileManager {
    private static final String PROFILES_DIR = "/data/storage/el2/base/minecraft/profiles";
    
    /**
     * User profile class
     */
    public static class UserProfile {
        private String id;
        private String name;
        private String username;
        private String uuid;
        private String accessToken;
        private String version;
        private String gameDir;
        private long lastPlayed;
        private int playtime; // in seconds
        
        public UserProfile() {
            this.id = UUID.randomUUID().toString();
            this.username = "Player";
            this.uuid = UUID.randomUUID().toString().replace("-", "");
            this.accessToken = "0";
            this.lastPlayed = 0;
            this.playtime = 0;
        }
        
        // Getters and setters
        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        
        public String getUuid() { return uuid; }
        public void setUuid(String uuid) { this.uuid = uuid; }
        
        public String getAccessToken() { return accessToken; }
        public void setAccessToken(String accessToken) { this.accessToken = accessToken; }
        
        public String getVersion() { return version; }
        public void setVersion(String version) { this.version = version; }
        
        public String getGameDir() { return gameDir; }
        public void setGameDir(String gameDir) { this.gameDir = gameDir; }
        
        public long getLastPlayed() { return lastPlayed; }
        public void setLastPlayed(long lastPlayed) { this.lastPlayed = lastPlayed; }
        
        public int getPlaytime() { return playtime; }
        public void setPlaytime(int playtime) { this.playtime = playtime; }
    }
    
    public ProfileManager() {
        initializeProfilesDirectory();
    }
    
    private void initializeProfilesDirectory() {
        File profilesDir = new File(PROFILES_DIR);
        if (!profilesDir.exists()) {
            profilesDir.mkdirs();
        }
    }
    
    /**
     * Create a new profile
     */
    public UserProfile createProfile(String name, String version) {
        UserProfile profile = new UserProfile();
        profile.setName(name);
        profile.setVersion(version);
        profile.setGameDir(PROFILES_DIR + "/" + profile.getId());
        
        // Create profile directory
        File profileDir = new File(profile.getGameDir());
        profileDir.mkdirs();
        
        // Save profile
        saveProfile(profile);
        
        return profile;
    }
    
    /**
     * Save profile to file
     */
    public boolean saveProfile(UserProfile profile) {
        try {
            // TODO: Implement JSON serialization
            System.out.println("Saving profile: " + profile.getName());
            return true;
        } catch (Exception e) {
            System.err.println("Failed to save profile: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Load profile from file
     */
    public UserProfile loadProfile(String profileId) {
        try {
            // TODO: Implement JSON deserialization
            System.out.println("Loading profile: " + profileId);
            return new UserProfile();
        } catch (Exception e) {
            System.err.println("Failed to load profile: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Delete a profile
     */
    public boolean deleteProfile(String profileId) {
        try {
            UserProfile profile = loadProfile(profileId);
            if (profile != null) {
                File profileDir = new File(profile.getGameDir());
                if (profileDir.exists()) {
                    deleteDirectory(profileDir);
                }
                
                File profileFile = new File(PROFILES_DIR, profileId + ".json");
                if (profileFile.exists()) {
                    profileFile.delete();
                }
                
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("Failed to delete profile: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Recursively delete directory
     */
    private void deleteDirectory(File dir) {
        File[] files = dir.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory()) {
                    deleteDirectory(file);
                } else {
                    file.delete();
                }
            }
        }
        dir.delete();
    }
    
    /**
     * Get default profile
     */
    public UserProfile getDefaultProfile() {
        UserProfile profile = new UserProfile();
        profile.setName("Default");
        profile.setVersion("1.20.4");
        return profile;
    }
}