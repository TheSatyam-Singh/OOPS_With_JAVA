package com.bank.customers;

import com.bank.accounts.Account;

public class Customer {
    
    private String customerId;
    private String name;
    private Account account;
    
    public Customer() {
    }
    
    public Customer(String customerId, String name) {
        this.customerId = customerId;
        this.name = name;
    }
    
    public void linkAccount(Account account) {
        this.account = account;
        System.out.println("Account linked successfully");
    }
    
    public void displayCustomerDetails() {
        System.out.println("\n----- Customer Details -----");
        System.out.println("ID: " + customerId);
        System.out.println("Name: " + name);
        if (account != null) {
            System.out.println(account.toString());
        }
        System.out.println("----------------------------\n");
    }
    
    public String getCustomerId() {
        return customerId;
    }
    
    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public Account getAccount() {
        return account;
    }
    
    public void setAccount(Account account) {
        this.account = account;
    }
}
