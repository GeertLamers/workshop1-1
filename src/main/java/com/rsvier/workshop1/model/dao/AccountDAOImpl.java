package com.rsvier.workshop1.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Logger;
import com.rsvier.workshop1.controller.Main;
import com.rsvier.workshop1.database.DataSource;

public class AccountDAOImpl implements AccountDAO {
	
	private Logger logger = Logger.getLogger(AccountDAOImpl.class.getName());

	@Override
	public boolean login(String username, String password) {

			String query = "Select password from account where username = (?)";
			Boolean result = false;
			try (Connection connection = DataSource.getConnection();
					PreparedStatement statement = connection.prepareStatement(query);){
					logger.info("Connected to database");
					statement.setString(1, username);
					ResultSet resultSet = statement.executeQuery();
					while (resultSet.next()) {
						if (password.equals(resultSet.getString(1))) {
							logger.info("Login successful");
							result = true;	
						}
						else {
							logger.info("Login failed");
						}
					}

					if (!Main.hikariEnabled) connection.close(); // necessary for the JDBC
				}
			catch (SQLException e) {
				e.printStackTrace();
				result = false;
			}
			return result;
	}
	
	public ArrayList<String> getUsernameList() {
		String query = "Select username from account where id > 0";
		ArrayList<String> allOfTheUsers = new ArrayList<>();
		try (Connection connection = DataSource.getConnection();
			PreparedStatement statement = connection.prepareStatement(query);){
			logger.info("Connected to database");
			ResultSet resultSet = statement.executeQuery();
			while (resultSet.next()) {
				allOfTheUsers.add(resultSet.getObject(1) + "");
			}
			logger.info("List of usernames retrieved");
			if (!Main.hikariEnabled) connection.close(); // necessary for the JDBC
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		return allOfTheUsers;
	}
	
	@Override
	public int getUserID(String username) {
		int userID = -1;	
		String query = "Select customer_id from account where username = (?)";
		try (Connection connection = DataSource.getConnection();
				PreparedStatement statement = connection.prepareStatement(query);){
				logger.info("Connected to database");
				statement.setString(1, username);
				ResultSet resultSet = statement.executeQuery();
				while (resultSet.next()) {
					userID = resultSet.getInt(1);
					logger.info("User ID retrieved: " + userID);
				}
				if (!Main.hikariEnabled) connection.close(); // necessary for the JDBC
			}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return userID;
}
	
	public ArrayList<String> retrieveAccountProperties() { // retrieves the information we need from the customer from the tables
		ArrayList<String> resultSetAsArrayList = new ArrayList<>();
		String query = "select column_name from information_schema.columns\r\n" + 
				" where table_name = 'account'";
		String query2 =  "select column_name from information_schema.columns\r\n" + 
				" where table_name = 'customer'";
		try (Connection connection = DataSource.getConnection();
			PreparedStatement statement = connection.prepareStatement(query);
			ResultSet resultSet = statement.executeQuery();) {
			while (resultSet.next()) {
				int i = 1;
				resultSetAsArrayList.add(resultSet.getString(i));
				i++;
			}
			PreparedStatement statement2 = connection.prepareStatement(query2);
			ResultSet resultSet2 = statement2.executeQuery();
			while (resultSet2.next()) {
				int i = 1;
				resultSetAsArrayList.add(resultSet2.getString(i));
				i++;
				}
			resultSetAsArrayList.remove("id"); //necessary until I figure out how not to select these
			resultSetAsArrayList.remove("owner_type");
			resultSetAsArrayList.remove("customer_id");
			resultSetAsArrayList.remove("active");
			resultSetAsArrayList.remove("id");
			if (!Main.hikariEnabled) connection.close(); // necessary for the JDBC
		}
	
		catch (SQLException e) {
			e.printStackTrace();
		}
		return resultSetAsArrayList;
	}
	
	@Override
	public boolean createAccount(ArrayList<String> necessaryCustomerInformation, ArrayList<String> newUser) { // creates a new user
			String query = "INSERT INTO customer (first_name, last_name, last_name_preposition, email, phone_number) VALUES (?,?,?,?,?)";
			try (Connection connection = DataSource.getConnection();
				PreparedStatement statement = connection.prepareStatement(query);){
				statement.setString(1, newUser.get(2));
				statement.setString(2, newUser.get(3));
				statement.setString(3, newUser.get(4));
				statement.setString(4, newUser.get(5));
				statement.setString(5, newUser.get(6));
				statement.executeUpdate();
				if (!Main.hikariEnabled) connection.close(); // necessary for the JDBC
			}
			catch (SQLException e) {
				e.printStackTrace();
				return false;
			}
			
			query = "SELECT id FROM customer WHERE first_name = (?)";
			ResultSet resultSet = null;
			int id = 0;
			try (Connection connection = DataSource.getConnection();
				PreparedStatement statement = connection.prepareStatement(query);){
				statement.setString(1,  newUser.get(2));
				resultSet = statement.executeQuery();
				if (resultSet.next()) id = resultSet.getInt(1);
				if (!Main.hikariEnabled) connection.close(); // necessary for the JDBC
			}
			catch (SQLException e) {
				e.printStackTrace();
				return false;
			}
			
			query = "INSERT INTO account (customer_id, username, password, owner_type) VALUES (?,?,?,?)";
			try (Connection connection = DataSource.getConnection();
				PreparedStatement statement = connection.prepareStatement(query);){
				statement.setInt(1, id);
				statement.setString(2,  newUser.get(0));
				statement.setString(3,  newUser.get(1));
				statement.setString(4,  "whatever");
				statement.executeUpdate();
				if (!Main.hikariEnabled) connection.close(); // necessary for the JDBC
			}
			catch (SQLException e) {
				e.printStackTrace();
				return false;
			}
			
			return true;
	}

	@Override
	public boolean changePassword() {
		// TODO Auto-generated method stub
		return false;
	}
	


	@Override
	public boolean changeUsername() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean deleteAccount(String deleteThisUser) {
		boolean success = false;
		String query = "Delete from account where username = (?)";
		try (Connection connection = DataSource.getConnection();
			PreparedStatement statement = connection.prepareStatement(query);){
			logger.info("Connected to database");
			statement.setString(1,  deleteThisUser);
			statement.executeUpdate();
			success = true;
		}
		catch (SQLException e) {
			e.printStackTrace();
			success = false;
		}
		return success;
	}


	@Override
	public boolean isAdmin(int userID) {
		String query = "Select owner_type from account where customer_id = (?)";
		ResultSet resultSet = null;
		boolean isAdmin = false;
		try (Connection connection = DataSource.getConnection();
			PreparedStatement statement = connection.prepareStatement(query);){
			logger.info("Connected to database");
			statement.setInt(1,  userID);
			resultSet = statement.executeQuery();
			while (resultSet.next()) {
				if (resultSet.getString(1).equalsIgnoreCase("Admin")) {
					isAdmin = true;
					logger.info("User is admin");
				}
				else {
					logger.info("User is not admin");
				}
			}
			if (!Main.hikariEnabled) connection.close(); // necessary for the JDBC
		}
		catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
		return isAdmin;
	}


}
