//
//  FormButton.swift
//
//  Created by Matthew Patience on 2019-02-28.
//

import UIKit

public class FormButton: UIButton {
    
    private var inverse = true
    
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
        self.layer.borderColor = FormStyle.shared.fieldBorderColor.cgColor
        if inverse {
            self.setTitleColor(.white, for: .normal)
            self.setTitleColor(FormStyle.shared.buttonLabelColor, for: .highlighted)
            self.backgroundColor = FormStyle.shared.fieldBorderColor
        } else {
            self.setTitleColor(FormStyle.shared.buttonLabelColor, for: .normal)
            self.setTitleColor(.white, for: .highlighted)
            self.backgroundColor = .white
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            if inverse {
                self.backgroundColor = isHighlighted ? UIColor.white : FormStyle.shared.fieldBorderColor
            } else {
                self.backgroundColor = isHighlighted ? FormStyle.shared.fieldBorderColor : UIColor.white
            }
        }
    }
    
    public func setInverse(_ inverse: Bool) {
        self.inverse = inverse
        commonInit()
    }

}
