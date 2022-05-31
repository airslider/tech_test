import SwiftUI

@MainActor
final class RootFlow {

    private let services = AppServices()

    var rootView: some View {
        TabView {
            NavigationView {
                TransactionListView(
                    viewModel: TransactionListViewModel(
                        interactor: TransactionListInteractor(
                            repository: Repository(
                                storage: services.storage
                            )
                        )
                    )
                )
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("transaction-tab-title")
            }
            .tabItem {
                Label("transaction-tab-title", systemImage: "list.bullet")
            }
            .navigationViewStyle(StackNavigationViewStyle())

            NavigationView {
                InsightsView(
                    viewModel: InsightsViewModel(
                        repository: Repository(
                            storage: services.storage
                        )
                    )
                )
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("insights-tab-title")
            }
            .tabItem {
                Label("insights-tab-title", systemImage: "chart.pie.fill")
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }

}
