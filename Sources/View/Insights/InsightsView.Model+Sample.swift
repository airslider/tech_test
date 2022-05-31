import SwiftUI

extension InsightsView.Model {

    static func sample(
        title: String = "food",
        foregroundColor: Color = .orange
    ) -> CategoryView.Model {
        CategoryView.Model(
            titleKey: title,
            foregroundColor: foregroundColor,
            categoryId: "food"
        )
    }

    static func samples() -> [CategoryView.Model] {
        [
            .sample(title: "all", foregroundColor: .black),
            .sample(title: "food", foregroundColor: .blue),
            .sample(title: "health", foregroundColor: .orange),
            .sample(title: "entertainment", foregroundColor: .red),
            .sample(title: "shopping", foregroundColor: .green),
            .sample(title: "travel", foregroundColor: .yellow)
        ]
    }

}
