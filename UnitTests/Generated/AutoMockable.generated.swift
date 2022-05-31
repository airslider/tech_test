// Generated using Sourcery 1.8.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import Combine
@testable import TechChallenge

class RepositoryProtocolMock: RepositoryProtocol {

    //MARK: - categories

    var categoriesThrowableError: Error?
    var categoriesCallsCount = 0
    var categoriesCalled: Bool {
        return categoriesCallsCount > 0
    }
    var categoriesReturnValue: [TransactionModel.Category]!
    var categoriesClosure: (() async throws -> [TransactionModel.Category])?

    func categories() async throws -> [TransactionModel.Category] {
        if let error = categoriesThrowableError {
            throw error
        }
        categoriesCallsCount += 1
        if let categoriesClosure = categoriesClosure {
            return try await categoriesClosure()
        } else {
            return categoriesReturnValue
        }
    }

    //MARK: - transactions

    var transactionsForThrowableError: Error?
    var transactionsForCallsCount = 0
    var transactionsForCalled: Bool {
        return transactionsForCallsCount > 0
    }
    var transactionsForReceivedCategory: CategoryView.Model?
    var transactionsForReceivedInvocations: [CategoryView.Model?] = []
    var transactionsForReturnValue: [TransactionModel]!
    var transactionsForClosure: ((CategoryView.Model?) async throws -> [TransactionModel])?

    func transactions(for category: CategoryView.Model?) async throws -> [TransactionModel] {
        if let error = transactionsForThrowableError {
            throw error
        }
        transactionsForCallsCount += 1
        transactionsForReceivedCategory = category
        transactionsForReceivedInvocations.append(category)
        if let transactionsForClosure = transactionsForClosure {
            return try await transactionsForClosure(category)
        } else {
            return transactionsForReturnValue
        }
    }

    //MARK: - pinnedTransactions

    var pinnedTransactionsThrowableError: Error?
    var pinnedTransactionsCallsCount = 0
    var pinnedTransactionsCalled: Bool {
        return pinnedTransactionsCallsCount > 0
    }
    var pinnedTransactionsReturnValue: [TransactionModel]!
    var pinnedTransactionsClosure: (() async throws -> [TransactionModel])?

    func pinnedTransactions() async throws -> [TransactionModel] {
        if let error = pinnedTransactionsThrowableError {
            throw error
        }
        pinnedTransactionsCallsCount += 1
        if let pinnedTransactionsClosure = pinnedTransactionsClosure {
            return try await pinnedTransactionsClosure()
        } else {
            return pinnedTransactionsReturnValue
        }
    }

    //MARK: - togglePinState

    var togglePinStateForTransactionIdThrowableError: Error?
    var togglePinStateForTransactionIdCallsCount = 0
    var togglePinStateForTransactionIdCalled: Bool {
        return togglePinStateForTransactionIdCallsCount > 0
    }
    var togglePinStateForTransactionIdReceivedId: Int?
    var togglePinStateForTransactionIdReceivedInvocations: [Int] = []
    var togglePinStateForTransactionIdClosure: ((Int) async throws -> Void)?

    func togglePinState(forTransactionId id: Int) async throws {
        if let error = togglePinStateForTransactionIdThrowableError {
            throw error
        }
        togglePinStateForTransactionIdCallsCount += 1
        togglePinStateForTransactionIdReceivedId = id
        togglePinStateForTransactionIdReceivedInvocations.append(id)
        try await togglePinStateForTransactionIdClosure?(id)
    }

}
class TransactionListInteractorProtocolMock: TransactionListInteractorProtocol {
    var transactions: CurrentValueSubject<[TransactionModel], Never> {
        get { return underlyingTransactions }
        set(value) { underlyingTransactions = value }
    }
    var underlyingTransactions: CurrentValueSubject<[TransactionModel], Never>!

    //MARK: - categories

    var categoriesCallsCount = 0
    var categoriesCalled: Bool {
        return categoriesCallsCount > 0
    }
    var categoriesReturnValue: [TransactionModel.Category]!
    var categoriesClosure: (() async -> [TransactionModel.Category])?

    func categories() async -> [TransactionModel.Category] {
        categoriesCallsCount += 1
        if let categoriesClosure = categoriesClosure {
            return await categoriesClosure()
        } else {
            return categoriesReturnValue
        }
    }

    //MARK: - onSelect

    var onSelectCategoryThrowableError: Error?
    var onSelectCategoryCallsCount = 0
    var onSelectCategoryCalled: Bool {
        return onSelectCategoryCallsCount > 0
    }
    var onSelectCategoryReceivedCategory: CategoryView.Model?
    var onSelectCategoryReceivedInvocations: [CategoryView.Model?] = []
    var onSelectCategoryClosure: ((CategoryView.Model?) async throws -> Void)?

    func onSelect(category: CategoryView.Model?) async throws {
        if let error = onSelectCategoryThrowableError {
            throw error
        }
        onSelectCategoryCallsCount += 1
        onSelectCategoryReceivedCategory = category
        onSelectCategoryReceivedInvocations.append(category)
        try await onSelectCategoryClosure?(category)
    }

    //MARK: - pinnedStateChanged

    var pinnedStateChangedForThrowableError: Error?
    var pinnedStateChangedForCallsCount = 0
    var pinnedStateChangedForCalled: Bool {
        return pinnedStateChangedForCallsCount > 0
    }
    var pinnedStateChangedForReceivedTransaction: TransactionView.Model?
    var pinnedStateChangedForReceivedInvocations: [TransactionView.Model] = []
    var pinnedStateChangedForClosure: ((TransactionView.Model) async throws -> Void)?

    func pinnedStateChanged(for transaction: TransactionView.Model) async throws {
        if let error = pinnedStateChangedForThrowableError {
            throw error
        }
        pinnedStateChangedForCallsCount += 1
        pinnedStateChangedForReceivedTransaction = transaction
        pinnedStateChangedForReceivedInvocations.append(transaction)
        try await pinnedStateChangedForClosure?(transaction)
    }

}
