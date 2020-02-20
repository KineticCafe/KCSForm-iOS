//
//  CustomDropDownCell.swift
//  KCSForm-iOS
//
//  Created by Matthew Patience on 2019-10-08.
//

import UIKit
import DropDown

class CustomDropDownCell: DropDownCell {
    
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    @IBOutlet var colorView: UIView!
    @IBOutlet var stackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.optionLabel.textAlignment = FormStyle.shared.dropdownTextAlignment
        self.contentView.backgroundColor = FormStyle.shared.dropdownBackgroundColor
        
        self.leadingConstraint.constant = FormStyle.shared.dropdownHorizontalMargins
        self.trailingConstraint.constant = FormStyle.shared.dropdownHorizontalMargins
        self.contentView.layoutIfNeeded()
    }
    
    public func setColor(_ formColor: FormColor) {
        self.optionLabel.text = formColor.name
        self.colorView.backgroundColor = formColor.color
        self.colorView.isHidden = false
    }
    
    public func setString(_ string: String) {
        self.optionLabel.text = string
        self.colorView.isHidden = true
    }
    
}
