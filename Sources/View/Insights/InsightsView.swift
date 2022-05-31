import SwiftUI

struct InsightsView: View {

    @ObservedObject var viewModel: InsightsViewModel
    
    var body: some View {
        GeometryReader { geometryData in
            List {
                RingView(viewModel: viewModel)
                    .frame(minHeight: geometryData.size.width)

                ForEach(viewModel.categoriesSummaryModels) { model in
                    HStack {
                        Text(model.titleKey.localized)
                            .font(.headline)
                            .foregroundColor(model.backgroundColor)
                        Spacer()
                        Text(model.amount)
                            .bold()
                            .secondary()
                    }
                }
            }
            .listStyle(.plain)
            .onAppear {
                viewModel.viewDidAppear()
            }
        }
    }

}

#if DEBUG
struct InsightsView_Previews: PreviewProvider {

    private static let viewModel: InsightsViewModel = {
        let viewModel = InsightsViewModel(repository: RepositoryMock())
        viewModel.viewDidAppear()
        return viewModel
    }()

    static var previews: some View {
        InsightsView(viewModel: viewModel)
            .previewLayout(.device)
    }

}

private final class RepositoryMock: RepositoryProtocol {

    func categories() async throws -> [TransactionModel.Category] {
        []
    }

    func transactions(for category: CategoryView.Model?) async throws -> [TransactionModel] {
        []
    }

    func togglePinState(forTransactionId id: Int) async throws { }

    func pinnedTransactions() async throws -> [TransactionModel] {
        [
            TransactionModel.sample(),
            TransactionModel.sample(category: .food, amount: 10.32),
            TransactionModel.sample(amount: 1.32),
            TransactionModel.sample(amount: 13),
        ]
    }

}
#endif
