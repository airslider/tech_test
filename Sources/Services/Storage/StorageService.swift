import CoreData
import Combine

protocol StorageServiceProtocol {
    func fetchCategories() async throws -> [CategoryDBDto]
    func fetchTransactions(for category: String?) async throws -> [TransactionDBDto]
    func fetchTransaction(with id: Int) async throws -> TransactionDBDto?
    func fetchTransactionsPinned() async throws -> [TransactionDBDto]
}

final class StorageService {

    private var storeInitError: Error?
    private var container: NSPersistentContainer?
    private var context: NSManagedObjectContext?
    private let semaphore = DispatchSemaphore(value: 1)

    init() {
        Task {
            await loadStore()
        }
    }

}

private extension StorageService {

    func loadStore() async {
        self.semaphore.wait()
        self.container = NSPersistentContainer(name: "Transactions")
        self.container?.loadPersistentStores { _, error in
            self.storeInitError = error
            if error == nil {
                self.context = self.container?.newBackgroundContext()
                if let context = self.context {
                    SampleDataMigration.start(using: context)
                }
            }
            self.semaphore.signal()
        }
    }

    func performRequest<T>(
        using predicate: NSPredicate = NSPredicate(value: true),
        limit: Int = 0,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) async throws -> [T] where T: NSManagedObject {
        defer {
            semaphore.signal()
        }

        if semaphore.wait(timeout: .now() + .seconds(5)) == .timedOut {
            throw AppError(.store)
        }

        guard storeInitError == nil else {
            throw storeInitError ?? AppError(.store)
        }

        guard
            let context = context,
            let entityName = T.entity().name
        else {
            throw AppError(.store)
        }

        return try await context.perform {
            let request = NSFetchRequest<T>(entityName: entityName)
            request.returnsObjectsAsFaults = false
            request.fetchLimit = limit
            request.sortDescriptors = sortDescriptors
            request.predicate = predicate
            return try context.fetch(request)
        }
    }

    func fetchCategories(by name: String) async throws -> CategoryDBDto? {
        let predicate = NSPredicate(format: "name == %@", name)
        return try await performRequest(using: predicate).first
    }

    func fetchAllTransactions() async throws -> [TransactionDBDto] {
        let sort = NSSortDescriptor(keyPath: \TransactionDBDto.date, ascending: false)
        return try await performRequest(sortDescriptors: [sort])
    }

}

extension StorageService: StorageServiceProtocol {

    func fetchTransactionsPinned() async throws -> [TransactionDBDto] {
        let predicate = NSPredicate(format: "%K == TRUE", #keyPath(TransactionDBDto.isPinned))
        return try await performRequest(using: predicate)
    }

    func fetchTransaction(with id: Int) async throws -> TransactionDBDto? {
        let predicate = NSPredicate(format: "%K == %d", #keyPath(TransactionDBDto.transactionId), id)
        return try await performRequest(using: predicate).first
    }

    func fetchTransactions(for category: String?) async throws -> [TransactionDBDto] {
        guard
            let category = category,
            let categoryDBDto = try await fetchCategories(by: category)
        else {
            return try await fetchAllTransactions()
        }

        let predicate = NSPredicate(format: "%K == %@", #keyPath(TransactionDBDto.category), categoryDBDto)
        let sort = NSSortDescriptor(keyPath: \TransactionDBDto.date, ascending: false)
        return try await performRequest(using: predicate, sortDescriptors: [sort])
    }

    func fetchCategories() async throws -> [CategoryDBDto] {
        let sort = NSSortDescriptor(keyPath: \CategoryDBDto.name, ascending: false)
        return try await performRequest(sortDescriptors: [sort])
    }

}
