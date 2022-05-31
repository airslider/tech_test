import SwiftUI

extension CategoryView {

    struct Model: Identifiable {
        let id: String
        let titleKey: String
        let foregroundColor: Color
        let categoryId: String

        init(
            titleKey: String,
            foregroundColor: Color,
            categoryId: String
        ) {
            self.id = titleKey
            self.titleKey = titleKey
            self.foregroundColor = foregroundColor
            self.categoryId = categoryId
        }
    }

}

extension CategoryView.Model {

    static func makeAll() -> CategoryView.Model {
        CategoryView.Model(
            titleKey: "category-all",
            foregroundColor: .black,
            categoryId: "all"
        )
    }

}
