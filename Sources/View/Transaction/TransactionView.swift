import SwiftUI

struct TransactionView: View {

    @ObservedObject var model: TransactionView.Model
    
    var body: some View {
        VStack {
            HStack {
                Text(model.category.titleKey.localized)
                    .font(.headline)
                    .foregroundColor(model.category.foregroundColor)
                Spacer()
                if model.isPinned {
                    Image(systemName: "pin.fill")
                } else {
                    Image(systemName: "pin.slash.fill")
                }
            }
            if model.isPinned {
                HStack {
                    model.image
                        .resizable()
                        .frame(
                            width: 60.0,
                            height: 60.0,
                            alignment: .top
                        )
                    VStack(alignment: .leading) {
                        Text(model.provider)
                            .secondary()
                        Text(model.account)
                            .tertiary()
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(model.amount)
                            .bold()
                            .secondary()
                        Text(model.date)
                            .tertiary()
                    }
                }
            }
        }
        .padding(8.0)
        .background(Color.accentColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
    }
}

#if DEBUG
struct TransactionView_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            TransactionView(
                model: TransactionView.Model(model: ModelData.sampleTransactions[0])
            )
            TransactionView(
                model: TransactionView.Model(model: ModelData.sampleTransactions[1])
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }

}
#endif
