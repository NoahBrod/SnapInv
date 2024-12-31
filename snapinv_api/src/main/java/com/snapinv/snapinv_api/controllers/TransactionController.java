package com.snapinv.snapinv_api.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.snapinv.snapinv_api.entities.Transaction;
import com.snapinv.snapinv_api.services.TransactionService;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;


@RestController
@RequestMapping(value = "/api/v1/transaction")
public class TransactionController {
    @Autowired
    private TransactionService transactionService;

    @GetMapping("/log")
    public List<Transaction> getTransactions() {
        return transactionService.getLog();
    }
    
}
