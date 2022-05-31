import SwiftUI

extension Angle {

    init(offset: Double, ratio: Double) {
        self = .degrees(360 * offset - 90 + 360 * ratio)
    }

}
