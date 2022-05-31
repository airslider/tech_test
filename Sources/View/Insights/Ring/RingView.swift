import SwiftUI

struct RingView: View {

    @ObservedObject var viewModel: InsightsViewModel
    
    var body: some View {
        ZStack {
            ForEach(viewModel.ringModels) { model in
                PartialCircleShape(
                    offset: model.startAngle,
                    ratio: model.ratio
                )
                .stroke(
                    gradient(for: model.startAngle, ratio: model.ratio, color: model.backgroundColor),
                    style: StrokeStyle(lineWidth: 28.0, lineCap: .butt)
                )
                .overlay(
                    PercentageText(
                        offset: model.startAngle,
                        ratio: model.ratio,
                        text: model.title
                    )
                )
            }
        }

    }
}

extension RingView {

    struct PartialCircleShape: Shape {
        let offset: Double
        let ratio: Double
        
        func path(in rect: CGRect) -> Path {
            Path(offset: offset, ratio: ratio, in: rect)
        }
    }
    
    struct PercentageText: View {
        let offset: Double
        let ratio: Double
        let text: String
        
        private func position(for geometry: GeometryProxy) -> CGPoint {
            let rect = geometry.frame(in: .local)
            let path = Path(offset: offset, ratio: ratio / 2.0, in: rect)
            return path.currentPoint ?? .zero
        }
        
        var body: some View {
            GeometryReader { geometry in
                Text(text)
                    .percentage()
                    .position(position(for: geometry))
            }
        }
    }

}

private extension RingView {

    func gradient(
        for offset: Double,
        ratio: Double,
        color: Color
    ) -> AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: [color.unsaturated, color]),
            center: .center,
            startAngle: .init(
                offset: offset,
                ratio: 0
            ),
            endAngle: .init(
                offset: offset,
                ratio: offset + ratio
            )
        )
    }

}

private extension Path {

    init(offset: Double, ratio: Double, in rect: CGRect) {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: CGFloat(150.0),
            startAngle: .init(offset: offset, ratio: 0),
            endAngle: .init(offset: offset, ratio: ratio),
            clockwise: false
        )
        self = path
    }

}

private extension Color {

    var unsaturated: Self {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0

        UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        return Color(hue: Double(hue), saturation: Double(saturation) * 0.6, brightness: Double(brightness))
    }
    
}

#if DEBUG
struct RingView_Previews: PreviewProvider {

    private static let viewModel: InsightsViewModel = {
        let viewModel = InsightsViewModel(repository: RepositoryMock())
        viewModel.viewDidAppear()
        return viewModel
    }()

    static var previews: some View {
        RingView(viewModel: viewModel)
            .scaledToFit()
            .previewLayout(.sizeThatFits)
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
