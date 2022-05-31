import Combine
import SwiftUI

@MainActor
final class FloatingSummaryViewModel: ObservableObject {

    @Published var amount: String = "--"
    @Published var category: CategoryView.Model = .makeAll()

    private let interactor: TransactionListInteractorProtocol
    private var observations = Set<AnyCancellable>()

    private lazy var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    init(
        interactor: TransactionListInteractorProtocol
    ) {
        self.interactor = interactor

        setupObservation()
    }

    deinit {
        observations.cancel()
    }

}

private extension FloatingSummaryViewModel {

    func setupObservation() {
        interactor.transactions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transactions in
                self?.calculateValues(with: transactions)
            }
            .store(in: &observations)
    }

    func calculateValues(with transactions: [TransactionModel]) {
        amount = amountString(with: transactions)
        category = category(with: transactions)
    }

    func amountString(with transactions: [TransactionModel]) -> String {
        let amountSummary = transactions
            .filter { $0.isPinned }
            .map { $0.amount }
            .reduce(0, +)
        return amountFormatter.string(for: amountSummary) ?? "--"
    }

    func category(with transactions: [TransactionModel]) -> CategoryView.Model {
        let categories = transactions
            .map { $0.category }
        let uniqueCategories = Set<TransactionModel.Category>(categories)
        if uniqueCategories.count == 1, let categoryToUse = uniqueCategories.first {
            return categoryToUse.toDisplayModel()
        } else {
            return CategoryView.Model.makeAll()
        }
    }

}
