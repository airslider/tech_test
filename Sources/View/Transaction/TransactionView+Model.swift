import Combine
import Foundation
import SwiftUI

extension TransactionView {

    final class Model: Identifiable, ObservableObject {
        let category: CategoryView.Model
        let id: Int
        let provider: String
        let account: String
        let amount: String
        let date: String
        let image: Image
        @Published var isPinned: Bool = false

        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("yyyyMMMd")
            return formatter
        }()

        private static let amountFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            return formatter
        }()

        init(model: TransactionModel) {
            id = model.id
            provider = model.provider?.rawValue ?? ""
            account = model.accountName
            amount = Self.amountFormatter.string(for: model.amount) ?? "--"
            date = Self.dateFormatter.string(from: model.date)
            category = model.category.toDisplayModel()
            image = Self.image(for: model)
            isPinned = model.isPinned
        }
    }

}

private extension TransactionView.Model {

    static func image(for model: TransactionModel) -> Image {
        if
            let provider = model.provider,
            let uiImage = UIImage(named: provider.rawValue)
        {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "questionmark.circle.fill")
        }
    }

}
