//
//  RhythmBeamer.swift
//  RhythmBeamer
//
//  Created by James Bean on 6/18/18.
//

import DataStructures
import func Math.countTrailingZeros
import MetricalDuration
import Rhythm
import SpelledRhythm

public enum DefaultBeamer {
    /// - Returns: A reasonable `Beaming` for the given `rhythm`.
    public static func beaming <T> (for rhythm: Rhythm<T>) -> Beaming {
        return .init(beamingVerticals(rhythm.metricalDurationTree.leaves))
    }
}

extension Beaming.Point.Vertical {

    /// - Returns: Singleton `Vertical`.
    static func singleton(_ cur: Int) -> Beaming.Point.Vertical {
        return .init(beamlets: cur)
    }

    /// - Returns: The `Vertical` for the first context in a rhythm.
    static func first(_ cur: Int, _ next: Int) -> Beaming.Point.Vertical {
        guard cur > 0 else { return .init() }
        guard next > 0 else { return .init(beamlets: cur) }
        return .init(start: Swift.min(cur,next), beamlets: Swift.max(0, cur - next))
    }

    /// - Returns: The `Vertical` for the context in a rhythm.
    static func middle(_ prev: Int, _ cur: Int, _ next: Int) -> Beaming.Point.Vertical {
        guard cur > 0 else { return .init() }
        guard prev > 0 else {
            guard next > 0 else { return .init(beamlets: Swift.max(0, cur - prev)) }
            return .init(start: Swift.min(cur, next), beamlets: Swift.max(0, cur - next))
        }
        guard next > 0 else {
            guard prev > 0 else { return .init(beamlets: Swift.max(0, cur - next)) }
            return .init(stop: Swift.min(cur, prev), beamlets: Swift.max(0, cur - prev))
        }
        let startCount = Swift.max(0, Swift.min(cur,next) - prev)
        let stopCount = Swift.max(0, Swift.min(cur,prev) - next)
        let startOrStop: Beaming.Point.StartOrStop = (
            startCount > 0 ? .start(count: startCount)
                : stopCount > 0 ? .stop(count: stopCount)
                : .none
        )
        return .init(
            maintain: Swift.min(prev,cur,next),
            startOrStop: startOrStop,
            beamlets: Swift.max(0, cur - Swift.max(prev,next))
        )
    }

    /// - Returns: The `Vertical` for the last context in a rhythm.
    static func last(_ prev: Int, _ cur: Int) -> Beaming.Point.Vertical {
        guard cur > 0 else { return .init() }
        guard prev > 0 else { return .init(beamlets: cur) }
        return .init(stop: Swift.min(cur,prev), beamlets: Swift.max(0, cur - prev))
    }

    /// Create a `Vertical` with the given context:
    ///
    /// - prev: Previous beaming count (if it exists)
    /// - cur: Current beaming count
    /// - next: Next beaming count (if it exists)
    public init(_ prev: Int?, _ cur: Int, _ next: Int?) {
        switch (prev, cur, next) {
        case (nil, cur, nil):
            self = .singleton(cur)
        case (nil, let cur, let next?):
            self = .first(cur, next)
        case (let prev?, let cur, let next?):
            self = .middle(prev, cur, next)
        case (let prev?, let cur, nil):
            self = .last(prev, cur)
        default:
            fatalError("Ill-formed context")
        }
    }
}

/// - Returns: An array of `Point.Vertical` values for the given `counts` (amounts of beams).
internal func beamingVerticals (_ counts: [Int]) -> [Beaming.Point.Vertical] {
    return counts.indices.map { index in
        let prev = counts[safe: index - 1]
        let cur = counts[index]
        let next = counts[safe: index + 1]
        return Beaming.Point.Vertical(prev,cur,next)
    }
}

/// - Returns: An array of `BeamJunction` values for the given `leaves`.
func beamingVerticals (_ leaves: [MetricalDuration]) -> [Beaming.Point.Vertical] {
    return beamingVerticals(leaves.map(beamCount))
}

/// - Returns: Amount of beams needed to represent the given `duration`.
func beamCount(_ duration: MetricalDuration) -> Int {

    let reduced = duration.reduced

    #warning("Support longer multi-dot durations with a (2 to the n) - 1 sequence")
    guard [1,3,7].contains(reduced.numerator) else {
        fatalError("Unsanitary duration for beamed representation: \(reduced)")
    }

    let subdivisionCount = countTrailingZeros(reduced.denominator) - 2

    if reduced.numerator.isDivisible(by: 3) {
        return subdivisionCount - 1
    } else if reduced.numerator.isDivisible(by: 7) {
        return subdivisionCount - 2
    }

    return subdivisionCount
}
