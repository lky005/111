package com.mclaunch.launcher;

import java.util.UUID;

/**
 * Launcher configuration management
 */
public class LauncherConfig {
    private String username = "Player";
    private String uuid = UUID.randomUUID().toString().replace("-", "");
    private String accessToken = "0";
    private int maxMemory = 2048; // MB
    private int minMemory = 512;  // MB
    private boolean fullscreen = false;
    private int windowWidth = 854;
    private int windowHeight = 480;
    private String javaPath = "java";
    
    public LauncherConfig() {
        // Load configuration from file if exists
        loadConfig();
    }
    
    private void loadConfig() {
        // TODO: Load from preferences/file
        // For now using defaults
    }
    
    public void saveConfig() {
        // TODO: Save to preferences/file
    }
    
    // Getters and setters
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getUuid() {
        return uuid;
    }
    
    public void setUuid(String uuid) {
        this.uuid = uuid;
    }
    
    public String getAccessToken() {
        return accessToken;
    }
    
    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }
    
    public int getMaxMemory() {
        return maxMemory;
    }
    
    public void setMaxMemory(int maxMemory) {
        this.maxMemory = maxMemory;
    }
    
    public int getMinMemory() {
        return minMemory;
    }
    
    public void setMinMemory(int minMemory) {
        this.minMemory = minMemory;
    }
    
    public boolean isFullscreen() {
        return fullscreen;
    }
    
    public void setFullscreen(boolean fullscreen) {
        this.fullscreen = fullscreen;
    }
    
    public int getWindowWidth() {
        return windowWidth;
    }
    
    public void setWindowWidth(int windowWidth) {
        this.windowWidth = windowWidth;
    }
    
    public int getWindowHeight() {
        return windowHeight;
    }
    
    public void setWindowHeight(int windowHeight) {
        this.windowHeight = windowHeight;
    }
    
    public String getJavaPath() {
        return javaPath;
    }
    
    public void setJavaPath(String javaPath) {
        this.javaPath = javaPath;
    }
}