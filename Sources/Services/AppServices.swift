final class AppServices {

    private(set) lazy var storage: StorageServiceProtocol = StorageService()

    init() {
        Task {
            await warmupServices()
        }
    }

    private func warmupServices() async {
        _ = storage
    }

}
