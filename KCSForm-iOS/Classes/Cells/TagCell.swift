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
        self.label.font = FormStyle.shared.tagFont
        updateStyle()
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
            self.contentView.backgroundColor = FormStyle.shared.fieldBorderColor
            self.label.textColor = .white
        } else {
            self.contentView.backgroundColor = .clear
            self.label.textColor = FormStyle.shared.buttonLabelColor
        }
    }
    
    private func updateStyle() {
        self.contentView.layer.cornerRadius = FormStyle.shared.tagCornerRadius
        self.contentView.layer.borderWidth = FormStyle.shared.tagBorderWidth
        self.contentView.layer.borderColor = FormStyle.shared.tagBorderColor.cgColor
    }

}
