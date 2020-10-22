//
//  FirstViewModelTestCase.swift
//  TextFieldTextModificationTests
//
//  Created by Anish on 10/21/20.
//  Copyright © 2020 Anish Kodeboyina. All rights reserved.
//

import XCTest

@testable import TextFieldTextModification

class FirstViewModelTestCase: XCTestCase {
        
    var viewModel: FirstViewModel!
    
    override func setUp() {
        super.setUp()
        
        viewModel = FirstViewModel()
    }
    
    func test_maxLimit() {
        XCTAssertEqual(viewModel.maxCharLimit, 15)
    }
    
    func test_shouldInsertHyphen() {
        let value = viewModel.shouldInsertHyphen(count: 2)
        XCTAssertTrue(value)
        
        let value6 = viewModel.shouldInsertHyphen(count: 6)
        XCTAssertTrue(value6)
        
        let value13 = viewModel.shouldInsertHyphen(count: 13)
        XCTAssertTrue(value13)
        
        
        [0, 1, 14, 12].forEach { (number) in
            let value1 = viewModel.shouldInsertHyphen(count: number)
            XCTAssertFalse(value1)
        }
    }
    
    func test_modifiedText() {
        let firstText = "NL"
        let modifiedText = viewModel.modifiedText(text: firstText)
        XCTAssertEqual(modifiedText, "NL-")
        
        //continuing typing NF-FRD, - should be added to position 7 and should show as NL-FRD-
        let secondText = "NF-FRD"
        let modifiedText1 = viewModel.modifiedText(text: secondText)
        XCTAssertEqual(modifiedText1, "NL-FRD-")
        
        //continuing typing NL-FRD-123456, - should be added to position 14 and should show as NL-FRD-111111-
        let thirdText = "NL-FRD-123456"
        let modifiedText2 = viewModel.modifiedText(text: thirdText)
        XCTAssertEqual(modifiedText2, "NL-FRD-111111-")
        
        let fourthText = "NL-FR"
        let modifiedText3 = viewModel.modifiedText(text: fourthText)
        XCTAssertEqual(modifiedText3, fourthText)
        
        //continuing typing.. after 15 character count is reached,
        //the user should be restricted from typing anymore.
        //final output should be something likes this NL-FRD-111111-1
        
        let fifthtext = "NL-FRD-111111-4"
        let modifiedText4 = viewModel.modifiedText(text: fifthtext)
        XCTAssertEqual(modifiedText4, "NL-FRD-111111-1")
        
        let sixthText = "NL-FRD-12343"
        let modifiedText5 = viewModel.modifiedText(text: sixthText)
        XCTAssertEqual(modifiedText5, sixthText)
        
        let seventhText = "NL-FRD-111111-A"
        let modifiedText6 = viewModel.modifiedText(text: seventhText)
        XCTAssertEqual(modifiedText6, "NL-FRD-111111-1")
    }
    
    func test_isTextWithInTheLimit() {
        // characters should be less than 15 characters
        XCTAssertFalse(viewModel.isTextWithInTheLimit("NL-FRD-111111-A"))
        XCTAssertTrue(viewModel.isTextWithInTheLimit("NL-FRD-111111"))
        XCTAssertFalse(viewModel.isTextWithInTheLimit("123456789012345"))
        XCTAssertTrue(viewModel.isTextWithInTheLimit("12345678901234"))
    }
    
    func test_isAplhaNumeric() {
        ["123", "abc1234", "ABC1234", "ABCD"].forEach { (string) in
           XCTAssertTrue(string.isAlphaNumeric)
        }
        
        ["123-", "abc1234;", "ABC@1234", "AB-CD"].forEach { (string) in
           XCTAssertFalse(string.isAlphaNumeric)
        }
    }
    
    func test_isTextValid() {
        ["NL-FRD-111111-A", "AB-CD"].forEach { (string) in
            XCTAssertFalse(viewModel.isTextValid(for: string, char: "-"))
        }
        
        ["NL-FRD-1111", "ABCD"].forEach { (string) in
            XCTAssertTrue(viewModel.isTextValid(for: string, char: "A"))
        }
    }
    
    func test_rangeOfText() {
        let nsRange: NSRange = NSRange(location: 0, length: 0)
        XCTAssertNotNil(viewModel.rangeOfText(nsRange, for: "A"))
    }
    
    func test_getModifiedText() {
        let nsRange: NSRange = NSRange(location: 0, length: 0)
        if let range = Range(nsRange, in: "A") {
            let text = viewModel.getModifiedTextFieldText(for: "", range: range, with: "A")
            XCTAssertEqual(text, "A")
        } else {
            XCTFail()
        }
    }
    
    func test_getScenario() {
        if case .replaceSingleCharacter = viewModel.getScenario(count: 6) {} else { XCTFail() }
        if case .replaceMultipleCharacter = viewModel.getScenario(count: 13) {} else { XCTFail() }
        if case .replaceSingleCharacter = viewModel.getScenario(count: 2) { XCTFail() } else {}
        if case .replaceMultipleCharacter = viewModel.getScenario(count: 2) { XCTFail() } else {}
        XCTAssertNil(viewModel.getScenario(count: 2))
    }
    
    func test_islastCharacter() {
        XCTAssertFalse(viewModel.islastCharacter(for: "NL-FRD-1"))
        XCTAssertTrue(viewModel.islastCharacter(for: "NL-FRD-111111-A"))
        XCTAssertFalse(viewModel.islastCharacter(for: "NL-FRD-111111"))
    }
    
    func test_configureIndexAndReplaceText() {
        let replacedvalue = viewModel.configureIndexAndReplaceText(for: "ABCDEF", at: 1, with: "-")
        XCTAssertEqual(replacedvalue, "A-CDEF")
        
        let replacedvalue1 = viewModel.configureIndexAndReplaceText(for: "NF-FRD", at: 1, with: "L")
        XCTAssertEqual(replacedvalue1, "NL-FRD")
        
        let replacedvalue2 = viewModel.configureIndexAndReplaceText(for: "NL-FRD-1111", at: 10, with: "0")
        XCTAssertEqual(replacedvalue2, "NL-FRD-1110")
    }
    
    func test_replaceText() {
        let text = "ABCDEF"
        let offset = 4
        let index = text.index(text.startIndex, offsetBy: offset)
        let result = viewModel.replaceText(for: text, at: index, with: "1")
        XCTAssertEqual(result, "ABCD1F")
    }
    
}


