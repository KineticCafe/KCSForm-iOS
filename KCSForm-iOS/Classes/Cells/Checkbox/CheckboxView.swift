//
//  CheckboxView.swift
//  Kiehls
//
//  Created by Matthew Patience on 2018-08-03.
//  Copyright © 2018 Kinetic Cafe. All rights reserved.
//

import UIKit

protocol CheckboxViewDelegate {
    func checkboxView(_ view: CheckboxView, checked: Bool)
}

class CheckboxView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var checkmarkImage: UIImageView!
    @IBOutlet var checkmarkBgView: UIView!
    
    private var checked: Bool = true
    public var style: FormStyle = FormStyle.shared {
        didSet {
            updateStyle()
        }
    }
    public var delegate: CheckboxViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        Bundle(for: FormViewController.self).loadNibNamed("CheckboxView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let bundle = Bundle(for: FormViewController.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("Images.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        self.checkmarkImage.image = UIImage(named: "ic_checkbox", in: resourceBundle, compatibleWith: nil)
        
        updateStyle()
    }
    
    private func updateStyle() {
        checkmarkBgView.layer.borderWidth = self.style.fieldBorderWidth
        checkmarkBgView.layer.cornerRadius = self.style.fieldCornerRadius
        checkmarkBgView.layer.borderColor = self.style.fieldBorderColor.cgColor
        self.titleLabel.font = self.style.fieldEntryFont
        updateCheckedState()
    }
    
    public func setChecked(_ checked: Bool) {
        
        self.checked = checked
        updateCheckedState()
        
    }
    
    private func updateCheckedState() {
        
        checkmarkImage.isHidden = !checked
        if checked {
            checkmarkBgView.backgroundColor = self.style.fieldBorderColor
        } else {
            checkmarkBgView.backgroundColor = .white
        }
        
    }
    
    @IBAction func pressedCheckmark(_ button: UIButton) {
        
        self.checked = !checked
        updateCheckedState()
        delegate?.checkboxView(self, checked: self.checked)
        
    }

}
