package com.snapinv.snapinv_api.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.snapinv.snapinv_api.entities.Transaction;
import com.snapinv.snapinv_api.repositories.TransactionRepo;

@Service
public class TransactionService {
    @Autowired
    private TransactionRepo transactionRepo;

    /**
     * Saves the a created transaction to the database.
     *
     * @param transaction Newly created transaction.
     * @return String.
     */
    public String newTransaction(Transaction transaction) {
        transactionRepo.save(transaction);

        return "Saved transaction.";
    }

    /**
     * Saves the a created transaction to the database.
     *
     * @return List of all transactions in the database.
     */
    public List<Transaction> getLog() {
        return transactionRepo.findAll();
    }
}
