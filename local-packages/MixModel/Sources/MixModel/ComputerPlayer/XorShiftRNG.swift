import Foundation

/// Using SystemRandomNumberGenerator would make the MonteCarloPlayer at least 12% slower.
/// So use a very fast custom solution. Not thread safe and bad statistical features. But good enough for picking the next move.
/// C implementation found here: https://en.wikipedia.org/wiki/Xorshift
class XorShiftRNG: RandomNumberGenerator {

    private var state: UInt64

    init(_ seed: UInt64) {
        state = seed
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
