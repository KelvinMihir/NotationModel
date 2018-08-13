////
////  Pitch+Pitch.Spelling.swift
////  SpelledPitch
////
////  Created by James Bean on 5/2/16.
////
////

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import Pitch

extension Pitch {

    /// All `Pitch.Spelling` structures available for this `Pitch`.
    public var spellings: [Pitch.Spelling] {
        return self.class.spellings
    }

    /// The first available `Pitch.Spelling` for this `Pitch`, if present. Otherwise `nil`.
    public var defaultSpelling: Pitch.Spelling {
        return PitchSpellings.defaultSpelling(forPitchClass: self.class)!
    }

    /// - returns: `SpelledPitch` with the given `Pitch.Spelling`,
    /// if the given `Pitch.Spelling` is valid for the `PitchClass` of the given `pitch`.
    ///
    /// - throws: `Pitch.Spelling.Error.InvalidPitchSpellingForPitch` if the given `spelling` is
    /// not appropriate for this `Pitch`.
    ///
    public func spelled(with spelling: Pitch.Spelling) throws -> SpelledPitch {

        var octave: Int {

            let unadjusted = Int(floor(noteNumber.value / 12.0)) - 1

            var mustAdjustForC: Bool {
                guard spelling.letterName == .c else { return false }
                if spelling.quarterStep.direction == .down { return true }
                return spelling.quarterStep == .natural && spelling.eighthStep == .down
            }

            var mustAdjustForB: Bool {
                guard spelling.letterName == .b else { return false }
                return spelling.quarterStep == .sharp && spelling.eighthStep.rawValue >= 0
            }

            return mustAdjustForC ? unadjusted + 1 : mustAdjustForB ? unadjusted - 1 : unadjusted
        }


        return SpelledPitch(spelling, octave)
    }

    /// - returns: `SpelledPitch` with the default spelling for this `Pitch`.
    public var spelledWithDefaultSpelling: SpelledPitch {
        return try! spelled(with: defaultSpelling)
    }
}
