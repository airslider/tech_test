import Foundation
import UIKit
import Combine

// sourcery: AutoMockable
protocol TransactionListInteractorProtocol {
    func categories() async -> [TransactionModel.Category]
    func onSelect(category: CategoryView.Model?) async throws
    func pinnedStateChanged(for transaction: TransactionView.Model) async throws

    var transactions: CurrentValueSubject<[TransactionModel], Never> { get }
}

final class TransactionListInteractor {

    private let repository: RepositoryProtocol
    private(set) var transactions = CurrentValueSubject<[TransactionModel], Never>([])
    private var selectedCategory: CategoryView.Model? = nil

    init(
        repository: RepositoryProtocol
    ) {
        self.repository = repository
    }

}

extension TransactionListInteractor: TransactionListInteractorProtocol {

    func pinnedStateChanged(for transaction: TransactionView.Model) async throws {
        try await repository.togglePinState(forTransactionId: transaction.id)
        try await transactionsForCurrentCategory()
    }

    func onSelect(category: CategoryView.Model?) async throws {
        selectedCategory = category
        try await transactionsForCurrentCategory()
    }

    func transaction(for category: CategoryView.Model?) async throws -> [TransactionModel] {
        try await repository.transactions(for: category)
    }

    func categories() async -> [TransactionModel.Category] {
        if let items = try? await repository.categories() {
            return [.all] + items
        } else {
            return []
        }
    }

}

private extension TransactionListInteractor {

    func transactionsForCurrentCategory() async throws {
        transactions.value = try await repository.transactions(for: selectedCategory)
    }

}
