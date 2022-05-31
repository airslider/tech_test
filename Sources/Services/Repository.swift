// sourcery: AutoMockable
protocol RepositoryProtocol {
    func categories() async throws -> [TransactionModel.Category]
    func transactions(for category: CategoryView.Model?) async throws -> [TransactionModel]
    func pinnedTransactions() async throws -> [TransactionModel]
    func togglePinState(forTransactionId id: Int) async throws
}

final class Repository {

    private let storage: StorageServiceProtocol

    init(
        storage: StorageServiceProtocol
    ) {
        self.storage = storage
    }

}

extension Repository: RepositoryProtocol {

    func pinnedTransactions() async throws -> [TransactionModel] {
        let transactionDbDtos = try await storage.fetchTransactionsPinned()
        return transactionDbDtos.first?.managedObjectContext?.performAndWait {
            return transactionDbDtos.compactMap { $0.toDomain() }
        } ?? []
    }

    func togglePinState(forTransactionId id: Int) async throws {
        if let transactionDbDto = try await storage.fetchTransaction(with: id) {
            try transactionDbDto.managedObjectContext?.performAndWait {
                transactionDbDto.isPinned.toggle()
                try transactionDbDto.managedObjectContext?.save()
            }
        }
    }

    func transactions(for category: CategoryView.Model?) async throws -> [TransactionModel] {
        let transactionDbDtos: [TransactionDBDto]
        if
            let category = category,
            let transactionCategory = TransactionModel.Category(rawValue: category.categoryId)
        {
            transactionDbDtos = try await storage.fetchTransactions(for: transactionCategory.rawValue)
        } else {
            transactionDbDtos = try await storage.fetchTransactions(for: nil)
        }

        return transactionDbDtos.first?.managedObjectContext?.performAndWait {
            return transactionDbDtos.compactMap { $0.toDomain() }
        } ?? []
    }

    func categories() async throws -> [TransactionModel.Category] {
        let categoriesDbDtos = try await storage.fetchCategories()
        return categoriesDbDtos.first?.managedObjectContext?.performAndWait {
            return categoriesDbDtos.compactMap { $0.toDomain() }
        } ?? []
    }

}

private extension CategoryDBDto {

    func toDomain() -> TransactionModel.Category? {
        guard let name = name else {
            return nil
        }

        return TransactionModel.Category(rawValue: name)
    }

}

private extension TransactionDBDto {

    func toDomain() -> TransactionModel? {
        guard
            let categoryName = self.category?.name,
            let category = TransactionModel.Category(rawValue: categoryName),
            let name = name,
            let date = date,
            let accountName = accountName,
            let provider = TransactionModel.Provider(rawValue: provider ?? "")
        else {
            return nil
        }

        return TransactionModel(
            id: Int(transactionId),
            name: name,
            category: category,
            amount: amount,
            date: date,
            accountName: accountName,
            provider: provider,
            isPinned: isPinned
        )
    }

}
