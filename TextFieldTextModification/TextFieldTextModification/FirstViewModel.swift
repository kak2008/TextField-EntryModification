//
//  FirstViewModel.swift
//  TextFieldTextModification
//
//  Created by Anish on 10/21/20.
//  Copyright © 2020 Anish Kodeboyina. All rights reserved.
//

import Foundation

class FirstViewModel: NSObject {
    
    var maxCharLimit = 15
    
    func isTextValid(for text: String, char: String) -> Bool {
        return char.isAlphaNumeric && isTextWithInTheLimit(text)
    }
    
    func rangeOfText(_ range: NSRange, for text: String) -> Range<String.Index>? {
        return Range(range, in: text)
    }
    
    func getModifiedTextFieldText(for text: String, range: Range<String.Index>, with char: String) -> String {
        let replacedText = text.replacingCharacters(in: range, with: char)
        return modifiedText(text: replacedText)
    }
    
    func isTextWithInTheLimit(_ text: String) -> Bool {
        text.count < maxCharLimit
    }
    
    func shouldInsertHyphen(count: Int) -> Bool {
        switch count {
        case 2, 6, 13:
            return true
        default:
            return false
        }
    }
    
    func getScenario(count: Int) -> Scenario? {
        switch count {
        case 6:
            return .replaceSingleCharacter
        case 13:
            return .replaceMultipleCharacter
        default:
            return nil
        }
    }
    
    func modifiedText(text: String) -> String {
        if shouldInsertHyphen(count: text.count) {
            var receivedText = text
        
            if let scenario = getScenario(count: text.count) {
                switch scenario {
                case .replaceSingleCharacter:
                    receivedText = configureIndexAndReplaceText(for: receivedText, at: 1, with: "L")
                case .replaceMultipleCharacter:
                    let array = (7...12).map{ $0 }
                    array.forEach { (num) in
                        receivedText = configureIndexAndReplaceText(for: receivedText, at: num, with: "1")
                    }
                }
            }
            
            return receivedText + "-"
        }
        
        guard islastCharacter(for: text) else { return text }
        return configureIndexAndReplaceText(for: text, at: text.count - 1, with: "1")
    }
    
    func islastCharacter(for text: String) -> Bool {
        text.count == maxCharLimit
    }
    
    func configureIndexAndReplaceText(for text: String, at offset: Int, with char: Character) -> String {
        let index = text.index(text.startIndex, offsetBy: offset)
        return replaceText(for: text, at: index, with: char)
    }
    
    func replaceText(for text: String, at location: String.Index, with char: Character) -> String {
        var currentText = text
        currentText.remove(at: location)
        currentText.insert(char, at: location)
        return currentText
    }
}
