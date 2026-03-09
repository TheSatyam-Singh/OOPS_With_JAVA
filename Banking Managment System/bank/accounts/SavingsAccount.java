package com.bank.accounts;

public class SavingsAccount extends Account {
    
    private double interestRate;
    
    public SavingsAccount() {
        super();
    }
    
    public SavingsAccount(String accountNumber, double balance, double interestRate) {
        super(accountNumber, balance);
        this.interestRate = interestRate;
    }
    
    public double calculateInterest() {
        double interest = balance * interestRate / 100;
        System.out.println("Interest: " + interest);
        return interest;
    }
    
    public void addInterest() {
        double interest = calculateInterest();
        balance = balance + interest;
        System.out.println("Balance after interest: " + balance);
    }
    
    public double getInterestRate() {
        return interestRate;
    }
    
    public void setInterestRate(double interestRate) {
        this.interestRate = interestRate;
    }
    
    public String toString() {
        return super.toString() + ", Interest Rate: " + interestRate + "%";
    }
}
