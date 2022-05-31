import Foundation
import Combine

extension String {

    var localized: String {
        NSLocalizedString(self, comment: "")
    }

}

extension Set where Element == AnyCancellable {

    func cancel() {
        forEach { $0.cancel() }
    }

}
