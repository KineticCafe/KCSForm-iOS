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
    
    public var style: FormStyle = FormStyle.shared {
        didSet {
            updateStyle()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateStyle()
    }
    
    private func updateStyle() {
        self.optionLabel.textAlignment = self.style.dropdownTextAlignment
        self.contentView.backgroundColor = self.style.dropdownBackgroundColor
        self.leadingConstraint.constant = self.style.dropdownHorizontalMargins
        self.trailingConstraint.constant = self.style.dropdownHorizontalMargins
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
