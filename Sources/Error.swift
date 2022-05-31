import Foundation

struct AppError: Error {

    enum Case: Int {
        case generic
        case store
        case inherited
    }

    private let type: Case
    private let error: Error?

    init(_ type: Case) {
        self.type = type
        self.error = nil
    }

    init(with error: Error) {
        self.error = error
        type = .inherited
    }

}

extension AppError: LocalizedError {

    var errorDescription: String? {
        switch type {
        case .generic:
            return "error-common".localized

        case .store:
            return "error-store".localized

        case .inherited:
            return error?.localizedDescription
        }
    }

}

extension Error {

    var appError: AppError {
        .init(with: self)
    }

}
