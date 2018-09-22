//
//  TendencyTests.swift
//  SpelledPitchTests
//
//  Created by James Bean on 9/21/18.
//

import XCTest
import Pitch
@testable import SpelledPitch

class PitchSpellingTendencyTests: XCTestCase {

    // MARK: - Category "Zero"

    func testPCZeroUpDown_CNatural() {
        let expected = Pitch.Spelling<EDO12>(.c)
        XCTAssertEqual(Pitch.Spelling.init(pitchClass: 0, tendencies: .init(.up,.down)), expected)
    }

    // MARK: - Category "One"

    func testPCSixUpUp_EDoubleSharp() {
        let expected = Pitch.Spelling<EDO12>(.e, .sharp(2))
        XCTAssertEqual(Pitch.Spelling.init(pitchClass: 6, tendencies: .init(.up,.up)), expected)
    }

    // MARK: - Category "Two"

    func testPCNineDownDown_BDoubleFlat() {
        let expected = Pitch.Spelling<EDO12>(.b, .flat(2))
        XCTAssertEqual(Pitch.Spelling.init(pitchClass: 9, tendencies: .init(.down,.down)), expected)
    }

    // MARK: - Category "Three"

    func testPCThreeUpDown_EFlat() {
        let expected = Pitch.Spelling<EDO12>(.e, .flat(1))
        XCTAssertEqual(Pitch.Spelling.init(pitchClass: 3, tendencies: .init(.up,.down)), expected)
    }

    // MARK: - Category "Four"

    func testPCElevenUpDown_BNatural() {
        let expected = Pitch.Spelling<EDO12>(.b, .natural)
        XCTAssertEqual(Pitch.Spelling.init(pitchClass: 11, tendencies: .init(.up,.down)), expected)
    }

    // MARK: - Category "Five"
    
    func testPCEightUpDown_GSharp() {
        let expected = Pitch.Spelling<EDO12>(.g, .sharp(1))
        XCTAssertEqual(Pitch.Spelling.init(pitchClass: 8, tendencies: .init(.up,.down)), expected)
    }
}