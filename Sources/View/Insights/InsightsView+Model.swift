import SwiftUI

extension InsightsView {

    final class Model: Identifiable {
        let id: String
        let titleKey: String
        let backgroundColor: Color
        let amount: String

        init(
            categoryModel: CategoryView.Model,
            amount: Double
        ) {
            self.id = categoryModel.id
            self.titleKey = categoryModel.titleKey
            self.backgroundColor = categoryModel.foregroundColor
            self.amount = Self.amountFormatter.string(for: amount) ?? "--"
        }

        private static let amountFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            return formatter
        }()
    }

}
