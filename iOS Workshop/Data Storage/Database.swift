//
//  Database.swift
//  iOS Workshop
//
//  Created by John Kotz on 1/30/18.
//  Copyright © 2018 You!. All rights reserved.
//

import Foundation
import CoreData

class Database {
	fileprivate static var instance: Database!
	fileprivate let container: NSPersistentContainer
	fileprivate var context: NSManagedObjectContext {
		return container.viewContext
	}
	
	static var balances: [Balance] {
		let balances = NSFetchRequest<NSFetchRequestResult>(entityName: "Balance")
		return try! instance.context.fetch(balances) as! [Balance]
	}
	
	static func newBalance(name: String, startingValue: Double) -> Balance {
		let balance = NSEntityDescription.insertNewObject(forEntityName: "Balance", into: instance.context) as! Balance
		balance.name = name
		balance.createdAt = Date()
		balance.startingValue = startingValue
		try! instance.context.save()
		return balance
	}
	
	private init() {
		self.container = NSPersistentContainer(name: "BalanceModel")
		self.container.loadPersistentStores { (storeDescription, error) in
			if let error = error {
				fatalError("Failed to load Core Data stack: \(error)")
			}
		}
	}
	static func setupInstance() {
		if Database.instance != nil {
			return
		}
		Database.instance = Database()
	}
}

extension Balance {
	public override var description: String {
		return "\(name ?? "no-name"):\n\tcreated at: \(createdAt?.description ?? "unknown")\n\tstarting value: \(startingValue)"
	}
	
	public var value: Double {
		var value = startingValue
		for transaction in transactions {
			value += transaction.ammount
		}
		return value
	}
	
	public var transactions: [Transaction] {
		guard let storedTransactions = storedTransactions else {
			return []
		}
		
		var transactions: [Transaction] = []
		
		for storedTransaction in storedTransactions {
			if let transaction = storedTransaction as? Transaction {
				transactions.append(transaction)
			}
		}
		
		return transactions
	}
	
	public func newTransaction(ammount: Double, memo: String?) -> Transaction {
		let transaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: Database.instance.context) as! Transaction
		
		transaction.ammount = ammount
		transaction.created = Date()
		transaction.memo = memo
		
		self.addToStoredTransactions(transaction)
		
		try! Database.instance.context.save()
		return transaction
	}
	
	public func delete() {
		for transaction in transactions {
			Database.instance.context.delete(transaction)
		}
		Database.instance.context.delete(self)
		try! Database.instance.context.save()
	}
}

extension Transaction {
	public func delete() {
		Database.instance.context.delete(self)
	}
}
