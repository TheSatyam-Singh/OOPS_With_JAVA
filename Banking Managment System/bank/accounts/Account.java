package com.bank.accounts;

import com.bank.exceptions.InsufficientBalanceException;
import com.bank.util.BankUtil;

public class Account {
    
    protected String accountNumber;
    protected double balance;
    
    public Account() {
    }
    
    public Account(String accountNumber, double balance) {
        this.accountNumber = accountNumber;
        this.balance = balance;
    }
    
    public void deposit(double amount) {
        balance = balance + amount;
        System.out.println("Deposited: " + amount);
        System.out.println("New Balance: " + balance);
    }
    
    public void withdraw(double amount) throws InsufficientBalanceException {
        if (amount > balance) {
            throw new InsufficientBalanceException("Not enough balance!");
        }
        
        double newBalance = balance - amount;
        BankUtil.validateMinimumBalance(newBalance);
        
        balance = balance - amount;
        System.out.println("Withdrawn: " + amount);
        System.out.println("Remaining Balance: " + balance);
    }
    
    public String getAccountNumber() {
        return accountNumber;
    }
    
    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }
    
    public double getBalance() {
        return balance;
    }
    
    public void setBalance(double balance) {
        this.balance = balance;
    }
    
    public String toString() {
        return "Account No: " + accountNumber + ", Balance: " + balance;
    }
}
