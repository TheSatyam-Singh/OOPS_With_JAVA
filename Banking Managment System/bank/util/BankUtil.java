package com.bank.util;

import com.bank.exceptions.InsufficientBalanceException;
import java.util.Random;

public class BankUtil {
    
    private static final double MINIMUM_BALANCE = 1000.0;
    private static Random random = new Random();
    
    public static String generateAccountNumber() {
        long accountNumber = 1000000000L + (long)(random.nextDouble() * 9000000000L);
        return String.valueOf(accountNumber);
    }
    
    public static void validateMinimumBalance(double balance) throws InsufficientBalanceException {
        if (balance < MINIMUM_BALANCE) {
            throw new InsufficientBalanceException("Balance below minimum!");
        }
    }
    
    public static double getMinimumBalance() {
        return MINIMUM_BALANCE;
    }
}
