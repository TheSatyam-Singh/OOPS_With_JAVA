package com.bank;

import com.bank.accounts.SavingsAccount;
import com.bank.customers.Customer;
import com.bank.loans.Loan;
import com.bank.exceptions.InsufficientBalanceException;
import static com.bank.util.BankUtil.generateAccountNumber;
import static com.bank.util.BankUtil.getMinimumBalance;

public class BankApplication {
    
    public static void main(String[] args) {
        System.out.println("Banking System");
        System.out.println("==============\n");
        
        try {
            System.out.println("1. Creating Customer");
            Customer customer = new Customer("CUST001", "Ratik Kumar");
            System.out.println("Customer created\n");
            
            System.out.println("2. Generating Account Number");
            String accountNumber = generateAccountNumber();
            System.out.println("Account Number: " + accountNumber + "\n");
            
            System.out.println("3. Creating Savings Account");
            SavingsAccount savingsAccount = new SavingsAccount(accountNumber, 5000.0, 4.5);
            System.out.println("Account created\n");
            
            System.out.println("4. Linking Account");
            customer.linkAccount(savingsAccount);
            System.out.println();
            
            customer.displayCustomerDetails();
            
            System.out.println("5. Deposit Money");
            savingsAccount.deposit(3000.0);
            System.out.println();
            
            System.out.println("6. Withdraw Money");
            savingsAccount.withdraw(2000.0);
            System.out.println();
            
            System.out.println("7. Calculate Interest");
            savingsAccount.calculateInterest();
            savingsAccount.addInterest();
            System.out.println();
            
            customer.displayCustomerDetails();
            
            System.out.println("8. Try to withdraw more than balance");
            try {
                savingsAccount.withdraw(10000.0);
            } catch (InsufficientBalanceException e) {
                System.out.println("Error: " + e.getMessage());
                System.out.println();
            }
            
            System.out.println("9. Try to withdraw below minimum balance");
            try {
                savingsAccount.withdraw(5500.0);
            } catch (InsufficientBalanceException e) {
                System.out.println("Error: " + e.getMessage());
                System.out.println();
            }
            
            System.out.println("10. Create Loan");
            Loan loan = new Loan(500000.0, 8.5, 60);
            double emi = loan.calculateEMI();
            
            System.out.println("\nFinal Details:");
            customer.displayCustomerDetails();
            
            System.out.println("Program completed successfully!");
            
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
