import SwiftUI
import Combine

struct TransactionListView: View {

    @ObservedObject var viewModel: TransactionListViewModel
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.transactionModels) { model in
                    TransactionView(model: model)
                        .onTapGesture {
                            withAnimation(.interactiveSpring()) {
                                viewModel.onTransactionViewTap(model)
                            }
                        }
                }
                .listRowSeparator(.hidden)
            }
            .safeAreaInset(edge: .top) {
                CategoriesScrollView(viewModel: viewModel.categoriesViewModel)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .safeAreaInset(edge: .bottom) {
                FloatingSummaryView(viewModel: viewModel.floatingSummaryViewModel)
            }
            .listStyle(.plain)
        }
        .alert(
            isPresented: $viewModel.isErrorVisible,
            error: viewModel.error
        ) { }
    }

}

#if DEBUG
struct TransactionListView_Previews: PreviewProvider {

    static var previews: some View {
        TransactionListView(
            viewModel: TransactionListViewModel(
                interactor: TransactionListInteractorMock()
            )
        )
    }

}

private final class TransactionListInteractorMock: TransactionListInteractorProtocol {

    func pinnedStateChanged(for transaction: TransactionView.Model) async { }

    func categories() async -> [TransactionModel.Category] {
        []
    }

    func onSelect(category: CategoryView.Model?) async { }

    var transactions = CurrentValueSubject<[TransactionModel], Never>(
        ModelData.sampleTransactions
    )

}
#endif
