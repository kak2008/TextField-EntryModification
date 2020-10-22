//
//  ViewController.swift
//  TextFieldTextModification
//
//  Created by Anish on 10/21/20.
//  Copyright © 2020 Anish Kodeboyina. All rights reserved.
//

import UIKit
/*
from Reeganprabu Subramaniam (Ford) to Everyone:    4:24  PM
Requirement:
Only Alphanumerice values allowed. Total number of Alphanumerice allowed including "-" 15 count.
All characters should be in uppercase.
"-" hypen should be automatically added at position 3,7,14
typing NF in textfield should autopopulate - at the end and should show as "NF-"
continuing typing NF-FRD, - should be added to position 7 and should show as NL-FRD-
continuing typing NL-FRD-123456, - should be added to position 14 and should show as NL-FRD-111111-
continuing typing.. after 15 character count is reached, the user should be restricted from typing anymore.
final output should be something likes this NL-FRD-111111-1
reeganprabu@gmail.com
*/

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textfield: UITextField!
    
    var viewModel: FirstViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FirstViewModel()
        textfield.delegate = self
        textfield.autocapitalizationType = .allCharacters
        textfield.keyboardType = .alphabet
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard
            let viewModel = viewModel,
            let text = textField.text,
            viewModel.isTextValid(for: text, char: string),
            let rangeOfText = viewModel.rangeOfText(range, for: text) else { return false }
        
        textField.text = viewModel.getModifiedTextFieldText(for: text, range: rangeOfText, with: string)
        
        return false
    }
    
}
