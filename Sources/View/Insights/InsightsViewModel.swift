import Combine
import Foundation

@MainActor
final class InsightsViewModel: ObservableObject {

    @Published var categoriesSummaryModels: [InsightsView.Model] = []
    @Published var ringModels: [RingView.Model] = []

//    private let interactor: InsightsViewInteractorProtocol
private let repository: RepositoryProtocol

    init(
//        interactor: InsightsViewInteractorProtocol
        repository: RepositoryProtocol
    ) {
//        self.interactor = interactor
        self.repository = repository
    }

    func viewDidAppear() {
        self.updateView()
    }
    
}

private extension InsightsViewModel {

    func updateView() {
        Task {
            let transactions = try await repository.pinnedTransactions()
            async let categoriesSummaryModels = calculateGroupValues(for: transactions)
            async let ringViewModels = calculateRingValues(for: transactions)
            self.categoriesSummaryModels = await categoriesSummaryModels
            self.ringModels = await ringViewModels
        }
    }

    func calculateGroupValues(for transactions: [TransactionModel]) async -> [InsightsView.Model] {
        let groupedTransactions = Dictionary(grouping: transactions, by: { $0.category })
        let dataPairs = groupedTransactions
            .map {
                ($0.key.toDisplayModel(), $0.value.map { $0.amount }.reduce(0, +))
            }
        return dataPairs
            .sorted(by: { $0.1 > $1.1 })
            .map { InsightsView.Model(categoryModel: $0.0, amount: $0.1) }
    }

    func calculateRingValues(for transactions: [TransactionModel]) async -> [RingView.Model] {
        let groupedTransactions = Dictionary(grouping: transactions, by: { $0.category })
        let amountSummary = transactions
            .map { $0.amount }
            .reduce(0, +)

        let sortedDisplayModels = groupedTransactions
            .map {
                ($0.key.toDisplayModel(), $0.value.map { $0.amount }.reduce(0, +))
            }
            .sorted(by: { $0.1 > $1.1 })
            .enumerated()

        var result = [RingView.Model]()
        var angleAcumulator: Double = 0
        sortedDisplayModels.forEach { item in
            let ratio = item.element.1 / amountSummary
            result.append(
                RingView.Model(
                    categoryModel: item.element.0,
                    title: ringSectorTitle(ratio * 100),
                    startAngle: angleAcumulator,
                    ratio: ratio
                )
            )
            angleAcumulator += ratio
        }
        return result
    }

    func ringSectorTitle(_ value: Double) -> String {
        if value > 0, value < 1 {
            return "<1%"
        } else {
            return String(format: "%.0f%%", value)
        }
    }

}
