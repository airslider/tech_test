import SwiftUI

struct CategoriesScrollView: View {

    @ObservedObject var viewModel: CategoriesScrollViewModel

    var body: some View {
        ZStack {
            Color.accentColor.opacity(0.8)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.models) { model in
                        CategoryView(
                            model: model,
                            onSelect: viewModel.onSelect(category:)
                        )
                    }
                }
                .padding()
            }
        }
    }

}

#if DEBUG
struct CategoriesScrollView_Previews: PreviewProvider {

    static var previews: some View {
        CategoriesScrollView(
            viewModel: CategoriesScrollViewModel(
                interactor: TransactionListInteractor(
                    repository: Repository(storage: StorageService())
                )
            )
        )
        .previewLayout(
            .fixed(
                width: 320,
                height: 60
            )
        )
    }

}
#endif
