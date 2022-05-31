import Foundation
import Combine

@MainActor
final class TransactionListViewModel: ObservableObject {

    @Published private(set) var transactionModels: [TransactionView.Model] = []
    @Published private(set) var error: AppError? {
        didSet {
            isErrorVisible = error != nil
        }
    }
    @Published var isErrorVisible = false

    let categoriesViewModel: CategoriesScrollViewModel
    let floatingSummaryViewModel: FloatingSummaryViewModel

    private let interactor: TransactionListInteractorProtocol
    private var observations = Set<AnyCancellable>()

    init(
        interactor: TransactionListInteractorProtocol
    ) {
        self.interactor = interactor
        self.categoriesViewModel = CategoriesScrollViewModel(interactor: interactor)
        self.floatingSummaryViewModel = FloatingSummaryViewModel(interactor: interactor)

        setupObservation()
        fetchInitialTransactionsAsync()
    }

    deinit {
        observations.cancel()
    }

    func onTransactionViewTap(_ model: TransactionView.Model) {
        Task {
            do {
                try await interactor.pinnedStateChanged(for: model)
            } catch {
                self.error = error.appError
            }
        }
    }

}

private extension TransactionListViewModel {

    func setupObservation() {
        interactor.transactions
            .receive(on: DispatchQueue.main)
            .sink { transactions in
                self.transactionModels = transactions.map { TransactionView.Model(model: $0) }
            }
            .store(in: &observations)
    }

    func fetchInitialTransactionsAsync() {
        Task {
            do {
                try await fetchInitialTransactions()
            } catch {
                self.error = error.appError
            }
        }
    }

    func fetchInitialTransactions() async throws {
        try await interactor.onSelect(category: nil)
    }

}
