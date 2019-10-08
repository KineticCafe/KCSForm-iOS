//
//  CustomDropDownCell.swift
//  KCSForm-iOS
//
//  Created by Matthew Patience on 2019-10-08.
//

import UIKit
import DropDown

class CustomDropDownCell: DropDownCell {
    
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.optionLabel.textAlignment = FormStyle.shared.dropdownTextAlignment
        self.topConstraint.constant = FormStyle.shared.dropdownVerticalMargins
        self.bottomConstraint.constant = FormStyle.shared.dropdownVerticalMargins
        self.leadingConstraint.constant = FormStyle.shared.dropdownHorizontalMargins
        self.leadingConstraint.constant = FormStyle.shared.dropdownHorizontalMargins
        
        self.contentView.backgroundColor = FormStyle.shared.dropdownBackgroundColor
        
    }
    
}
