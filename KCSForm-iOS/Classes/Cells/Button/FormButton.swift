//
//  FormButton.swift
//  DropDown
//
//  Created by Matthew Patience on 2019-02-28.
//

import UIKit

class FormButton: UIButton {
    
    public var style: FormStyle = FormStyle.shared {
        didSet {
            updateStyle()
        }
    }
    
    private var inverse = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        updateStyle()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateStyle()
    }
    
    private func updateStyle() {
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = self.style.fieldCornerRadius
        self.layer.borderWidth = self.style.fieldBorderWidth
        self.titleLabel?.font = self.style.fieldButtonFont
        self.layer.borderColor = self.style.buttonBorderColor.cgColor
        if inverse {
            self.setTitleColor(.white, for: .normal)
            self.setTitleColor(self.style.buttonLabelColor, for: .highlighted)
            self.backgroundColor = self.style.buttonBorderColor
        } else {
            self.setTitleColor(self.style.buttonLabelColor, for: .normal)
            self.setTitleColor(.white, for: .highlighted)
            self.backgroundColor = .clear
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            if inverse {
                if isHighlighted {
                    self.backgroundColor = UIColor.white
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.backgroundColor = self.style.buttonBorderColor
                    })
                }
            } else {
                if isHighlighted {
                    self.backgroundColor = self.style.buttonBorderColor
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.backgroundColor = UIColor.white
                    })
                }
            }
        }
    }
    
    public func setInverse(_ inverse: Bool) {
        self.inverse = inverse
        updateStyle()
    }

}
