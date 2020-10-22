//
//  String+Extension.swift
//  TextFieldTextModification
//
//  Created by Anish on 10/21/20.
//  Copyright © 2020 Anish Kodeboyina. All rights reserved.
//

import Foundation

extension String {
    var isAlphaNumeric: Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
}
