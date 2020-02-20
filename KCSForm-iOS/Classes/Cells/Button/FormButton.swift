//
//  FormButton.swift
//  DropDown
//
//  Created by Matthew Patience on 2019-02-28.
//

import UIKit

public class FormButton: UIButton {
    
    private var inverse = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = FormStyle.shared.fieldCornerRadius
        self.layer.borderWidth = FormStyle.shared.fieldBorderWidth
        self.titleLabel?.font = FormStyle.shared.fieldButtonFont
        self.layer.borderColor = FormStyle.shared.buttonBorderColor.cgColor
        if inverse {
            self.setTitleColor(.white, for: .normal)
            self.setTitleColor(FormStyle.shared.buttonLabelColor, for: .highlighted)
            self.backgroundColor = FormStyle.shared.buttonBorderColor
        } else {
            self.setTitleColor(FormStyle.shared.buttonLabelColor, for: .normal)
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
                        self.backgroundColor = FormStyle.shared.buttonBorderColor
                    })
                }
            } else {
                if isHighlighted {
                    self.backgroundColor = FormStyle.shared.buttonBorderColor
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
        commonInit()
    }

}
