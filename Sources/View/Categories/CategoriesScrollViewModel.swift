import Combine
import SwiftUI

@MainActor
final class CategoriesScrollViewModel: ObservableObject {

    @Published private(set) var models: [CategoryView.Model] = []

    private let interactor: TransactionListInteractorProtocol

    init(
        interactor: TransactionListInteractorProtocol
    ) {
        self.interactor = interactor

        Task {
            await fetchCategoryList()
        }
    }

    func onSelect(category: CategoryView.Model) {
        Task {
            try? await interactor.onSelect(category: category)
        }
    }

}

private extension CategoriesScrollViewModel {

    func fetchCategoryList() async {
        models = await interactor.categories().map { $0.toDisplayModel() }
    }

}

extension TransactionModel.Category {

    func toDisplayModel() -> CategoryView.Model {
        CategoryView.Model(
            titleKey: "category-\(rawValue)",
            foregroundColor: color,
            categoryId: rawValue
        )
    }

}
