import SwiftUI

struct CategoryView: View {

    let model: Model
    let onSelect: @MainActor (Model) -> Void

    var body: some View {
        ZStack {
            model.foregroundColor
            Button {
                onSelect(model)
            } label: {
                Text(model.titleKey.localized)
                    .foregroundColor(.white)
                    .bold()
                    .font(.title2)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .fixedSize()
            }
        }
        .clipShape(
            RoundedRectangle(
                cornerSize: .init(
                    width: 20,
                    height: 20
                )
            )
        )
    }
    
}

#if DEBUG
struct CategoryView_Previews: PreviewProvider {

    static var previews: some View {
        CategoryView(model: .sample(), onSelect: { _ in })
            .previewLayout(
                .fixed(
                    width: 300,
                    height: 40
                )
            )
    }

}
#endif
