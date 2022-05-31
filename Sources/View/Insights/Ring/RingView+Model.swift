import SwiftUI

extension RingView {

    final class Model: Identifiable, ObservableObject {
        let id: String
        let title: String
        let backgroundColor: Color
        let startAngle: Double
        let ratio: Double

        init(
            categoryModel: CategoryView.Model,
            title: String,
            startAngle: Double,
            ratio: Double
        ) {
            self.id = categoryModel.id
            self.title = title
            self.backgroundColor = categoryModel.foregroundColor
            self.startAngle = startAngle
            self.ratio = ratio
        }
    }

}
