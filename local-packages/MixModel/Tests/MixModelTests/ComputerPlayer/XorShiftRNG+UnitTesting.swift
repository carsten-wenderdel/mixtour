import Foundation
@testable import MixModel

extension XorShiftRNG {
    static var reproducable: XorShiftRNG {
        return XorShiftRNG(0)
    }
}
