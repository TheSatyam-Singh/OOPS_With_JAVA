package com.bank.loans;

public class Loan {
    
    private double loanAmount;
    private double interestRate;
    private int tenure;
    
    public Loan() {
    }
    
    public Loan(double loanAmount, double interestRate, int tenure) {
        this.loanAmount = loanAmount;
        this.interestRate = interestRate;
        this.tenure = tenure;
    }
    
    public double calculateEMI() {
        double emi = (loanAmount * interestRate * tenure) / 100;
        System.out.println("\nLoan Amount: " + loanAmount);
        System.out.println("Interest Rate: " + interestRate + "%");
        System.out.println("Tenure: " + tenure + " months");
        System.out.println("Total Interest: " + emi);
        System.out.println("Total Payable: " + (loanAmount + emi));
        return emi;
    }
    
    public double getLoanAmount() {
        return loanAmount;
    }
    
    public void setLoanAmount(double loanAmount) {
        this.loanAmount = loanAmount;
    }
    
    public double getInterestRate() {
        return interestRate;
    }
    
    public void setInterestRate(double interestRate) {
        this.interestRate = interestRate;
    }
    
    public int getTenure() {
        return tenure;
    }
    
    public void setTenure(int tenure) {
        this.tenure = tenure;
    }
}
