//
//  TagCell.swift
//  KCSForm-iOS
//
//  Created by Matthew Patience on 2020-02-13.
//

import UIKit

class TagCell: FormCell {
    
    @IBOutlet var label: UILabel!
    private var widthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.label.font = self.style.tagFont
        setSelected(false)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.widthConstraint = self.contentView.widthAnchor.constraint(equalToConstant: 0)
    }
    
    public func setCellWidth(_ width: CGFloat) {
        self.widthConstraint.constant = width
        self.widthConstraint.isActive = true
    }
    
    public func setLabel(_ text: String) {
        self.label.text = text
    }
    
    public func setSelected(_ selected: Bool) {
        if selected {
            self.contentView.backgroundColor = self.style.fieldBorderColor
            self.label.textColor = .white
            self.label.font = self.style.tagSelectedFont
        } else {
            self.contentView.backgroundColor = .clear
            self.label.textColor = self.style.buttonLabelColor
            self.label.font = self.style.tagFont
        }
    }
    
    internal override func updateStyle() {
        self.contentView.layer.cornerRadius = self.style.tagCornerRadius
        self.contentView.layer.borderWidth = self.style.tagBorderWidth
        self.contentView.layer.borderColor = self.style.tagBorderColor.cgColor
    }

}
