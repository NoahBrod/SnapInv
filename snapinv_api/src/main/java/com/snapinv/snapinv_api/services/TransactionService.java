package com.snapinv.snapinv_api.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.snapinv.snapinv_api.entities.Transaction;
import com.snapinv.snapinv_api.repositories.TransactionRepo;

@Service
public class TransactionService {
    @Autowired
    private TransactionRepo transactionRepo;

    public String newTransactions(Transaction transaction) {
        transactionRepo.save(transaction);

        return "Failed to add transaction.";
    }
}
