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

    public String newTransaction(Transaction transaction) {
        transactionRepo.save(transaction);

        return "Saved transaction.";
    }

    public List<Transaction> getLog() {
        return transactionRepo.findAll();
    }
}
