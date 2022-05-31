import SwiftUI
import Combine

struct FloatingSummaryView: View {

    @ObservedObject var viewModel: FloatingSummaryViewModel

    var body: some View {
        HStack(alignment: .bottom) {
            Text("summary-total-spent")
                .secondary()
                .padding()
            Spacer()
            VStack(alignment: .trailing) {
                Text(viewModel.category.titleKey.localized)
                    .font(.headline)
                    .foregroundColor(viewModel.category.foregroundColor)
                Text(viewModel.amount)
                    .bold()
                    .secondary()
            }
            .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.accentColor, lineWidth: 2)
        )
        .padding(10)
        .background(.thinMaterial)
    }

}

#if DEBUG
struct FloatingSummaryView_Previews: PreviewProvider {

    static var previews: some View {
        FloatingSummaryView(
            viewModel: FloatingSummaryViewModel(
                interactor: TransactionListInteractorMock()
            )
        )
        .previewLayout(
            .fixed(
                width: 340,
                height: 90
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
