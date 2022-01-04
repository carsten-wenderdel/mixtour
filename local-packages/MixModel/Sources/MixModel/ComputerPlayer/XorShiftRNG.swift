import Foundation

/// Using SystemRandomNumberGenerator would make the MonteCarloPlayer at least 12% slower.
/// So use a very fast custom solution. Not thread safe and bad statistical features. But good enough for picking the next move.
/// C implementation found here: https://en.wikipedia.org/wiki/Xorshift
final class XorShiftRNG: RandomNumberGenerator {

    private static let defaultSeed: UInt64 = 88172645463325252
    private var state: UInt64

    static var random: XorShiftRNG {
        XorShiftRNG(UInt64.random(in: 1...UInt64.max))
    }

    static var reproducable: XorShiftRNG {
        XorShiftRNG(defaultSeed)
    }

    init(_ seed: UInt64) {
        state = seed == 0 ? XorShiftRNG.defaultSeed : seed
    }

    func next() -> UInt64 {
        var x = state
        x ^= x << 13
        x ^= x >> 7
        x ^= x << 17
        state = x
        return x
    }
}
