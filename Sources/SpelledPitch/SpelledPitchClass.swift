//
//  SpelledPitchClass.swift
//  SpelledPitch
//
//  Created by James Bean on 8/20/16.
//
//

import Pitch

/// Spelled pitch class.
public struct SpelledPitchClass: Spelled, Equatable {
    
    // MARK: - Instance Properties
    
    /// Pitch class.
    public let pitchClass: Pitch.Class
    
    /// Spelling.
    public let spelling: Pitch.Spelling
    
    // MARK: - Initializers
    
    /// Create a `SpelledPitchClass` (with argument labels).
    public init(pitchClass: Pitch.Class, spelling: Pitch.Spelling) {
        self.pitchClass = pitchClass
        self.spelling = spelling
    }
    
    /// Create a `SpelledPitchClass` (without argument labels).
    public init(_ pitchClass: Pitch.Class, _ spelling: Pitch.Spelling) {
        self.pitchClass = pitchClass
        self.spelling = spelling
    }
    
    // FIXME: Refine relationship between `Pitch.Spelling` and `SpelledPitchClass`.
    public init(_ spelling: Pitch.Spelling) {
        self.spelling = spelling
        self.pitchClass = spelling.pitchClass
    }
}

extension SpelledPitchClass: CustomStringConvertible {
    
    // MARK: - CustromStringConvertible
    
    /// Printed description.
    public var description: String {
        return "\(pitchClass): \(spelling)"
    }
}

extension SpelledPitchClass: Hashable {
    
    // MARK: - Hashable
    
    public var hashValue: Int {
        return "\(pitchClass)\(spelling)".hashValue
    }
}

// MARK: - Equatable

public func == (lhs: SpelledPitchClass, rhs: SpelledPitchClass) -> Bool {
    return lhs.pitchClass == rhs.pitchClass && lhs.spelling == rhs.spelling
}

// MARK: - Comparable


/// - TODO: Refine.
public func < (lhs: SpelledPitchClass, rhs: SpelledPitchClass) -> Bool {
    return lhs.pitchClass < rhs.pitchClass
}
