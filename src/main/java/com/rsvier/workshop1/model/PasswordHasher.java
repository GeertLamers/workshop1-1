package com.rsvier.workshop1.model;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

public class PasswordHasher {

		    private SecureRandom random;
		    private String password;
		    private String encryptedPass;
		    private String encryptedTotal;
		    public String saltString;

		    private byte[] generateSalt() {
		        this.random = new SecureRandom();
		        byte bytes[] = new byte[20];
		        this.random.nextBytes(bytes);
		        return bytes;
		    }

		    public String makeSaltedPasswordHash(String password) {
		        byte[] salt = generateSalt();
		        saltString = new String(salt);
		        this.password = password + saltString;
		        
		        try {
		            MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
		            messageDigest.update(this.password.getBytes());
		            this.encryptedPass = new String(messageDigest.digest());
		            this.encryptedTotal = this.encryptedPass + saltString;
		        } catch (NoSuchAlgorithmException e) {
		            System.out.println(e);
		        }
		        return this.encryptedTotal;
		    }
		    
		    
		    public String makeSaltedPasswordHash(String password, String hash) {
		        saltString = hash;
		        this.password = password + saltString;
		        
		        try {
		            MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
		            messageDigest.update(this.password.getBytes());
		            this.encryptedPass = new String(messageDigest.digest());
		            this.encryptedTotal = this.encryptedPass + saltString;
		        } catch (NoSuchAlgorithmException e) {
		            System.out.println(e);
		        }
		        return this.encryptedTotal;
		    }

		    public String hasher(String password) {
		        this.password = password;
		        try {
		            MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
		            messageDigest.update(password.getBytes());
		            this.encryptedPass = new String(messageDigest.digest());
		        } catch (NoSuchAlgorithmException e) {
		            System.out.println(e);
		        }
		        return this.encryptedPass;
		        }

}