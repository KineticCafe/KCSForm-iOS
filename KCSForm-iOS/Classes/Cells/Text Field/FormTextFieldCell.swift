//
//  FormTextFieldCell.swift
//  Kiehls
//
//  Created by Steven Andrews on 2018-05-28.
//  Copyright © 2018 Kinetic Cafe. All rights reserved.
//

import UIKit

protocol FormTextFieldCellDelegate {
    
    /** Called when the specified textfield text did change. */
    func formTextFieldCell(_ cell: FormTextFieldCell, updatedText: String?)
    
    /** Determines if the textfield should return. */
    func formTextFieldCellShouldReturn(_ cell: FormTextFieldCell, textField: UITextField) -> Bool
    
}

public class FormTextFieldCell: FormCell {
    
    public class Data: FormCellData {
        public var title: String?
        public var text: String?
        public var placeholder: String?
        public var keyboardType: UIKeyboardType
        public var returnKeyType: UIReturnKeyType
        public var formattingPattern: String?
        public var capitalizationType: UITextAutocapitalizationType
        public var isEditable: Bool
        public var errorText: String?
        
        public init(title: String? = nil, text: String? = nil, placeholder: String? = nil, keyboardType: UIKeyboardType = .default, returnKeyType: UIReturnKeyType = .next, formattingPattern: String? = nil, capitalizationType: UITextAutocapitalizationType = .none, isEditable:Bool = true, errorText:String? = nil) {
            self.title = title
            self.text = text
            self.placeholder = placeholder
            self.keyboardType = keyboardType
            self.returnKeyType = returnKeyType
            self.formattingPattern = formattingPattern
            self.capitalizationType = capitalizationType
            self.isEditable = isEditable
            self.errorText = errorText
        }
    }
    
    //IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var textFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var errorTopMarginConstraint: NSLayoutConstraint!
    
    //MARK: - Constants
    
    /* The text field horizontal inset */
    public static var textFieldInternalHorizontalInsets: CGFloat              = 10
    public static var textFieldHeight: CGFloat                                = 44
    
    private lazy var underlineLayer: CALayer = {
        let underline = CALayer()
        underline.borderColor = self.style.fieldBorderColor.cgColor
        underline.frame = CGRect(x: 0, y: textField.frame.size.height - self.style.fieldBorderWidth, width: textField.frame.size.width, height: textField.frame.size.height)
        underline.borderWidth = self.style.fieldBorderWidth
        return underline
    }()
    
    //Properties
    var delegate: FormTextFieldCellDelegate?
    
    /** Optional formatting pattern to be used for the cell. */
    fileprivate var formattingPattern: String?

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        self.textField.addTarget(self, action: #selector(onTextChange), for: .editingChanged)
        self.textField.delegate = self
        self.textField.backgroundColor = .clear
        self.textField.leftViewMode = .always
        self.textField.rightViewMode = .always
        self.textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: FormTextFieldCell.textFieldInternalHorizontalInsets, height: 0))
        self.textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: FormTextFieldCell.textFieldInternalHorizontalInsets, height: 0))
        self.textFieldHeightConstraint.constant = FormTextFieldCell.textFieldHeight
    }
    
    internal override func updateStyle() {
        self.titleLabel.textColor = self.style.fieldTitleColor
        self.titleLabel.font = self.style.fieldTitleFont
        self.stackView.spacing = self.style.fieldTitleBottomMargin
        self.errorLabel.textColor = self.style.fieldErrorColor
        self.errorLabel.font = self.style.fieldErrorFont
        self.errorTopMarginConstraint.constant = self.style.errorTopMargin
        self.textField.font = self.style.fieldEntryFont
        self.textField.textColor = self.style.fieldEntryColor
        self.textField.tintColor = self.style.formTint
        
        switch (self.style.textFieldStyle) {
        case .box:
            textField.layer.cornerRadius = self.style.fieldCornerRadius
            textField.layer.borderWidth = self.style.fieldBorderWidth
            textField.layer.borderColor = self.style.fieldBorderColor.cgColor
            break
        case .underline:
            textField.layer.addSublayer(underlineLayer)
            textField.layer.masksToBounds = true
            break
        case .none:
            underlineLayer.removeFromSuperlayer()
            textField.layer.cornerRadius = 0
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            break
        }
    }
    
    @objc fileprivate func onTextChange() {
        if let formattingPattern = formattingPattern, let replacementText = textField.text, !replacementText.isEmpty {
            textField.text = replacementText.formatWithPattern(formattingPattern, replacementChar: "*".first!)
        }
        
        delegate?.formTextFieldCell(self, updatedText: textField.text)
    }
    
    /* Public update function */
    public func update(_ data: Data) {
        
        titleLabel.isHidden = (data.title == nil)
        titleLabel.text = data.title
        textField.text = data.text
        
        if data.isEditable, let placeholder = data.placeholder {
            let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor : self.style.fieldPlaceholderColor])
            textField.attributedPlaceholder = attributedPlaceholder
        } else {
            textField.placeholder = ""
        }
        textField.keyboardType = data.keyboardType
        textField.autocapitalizationType = data.capitalizationType
        textField.returnKeyType = data.returnKeyType
        
        self.formattingPattern = data.formattingPattern
        
        textField.isUserInteractionEnabled = data.isEditable
        textField.layer.borderColor =  data.isEditable ? ((data.errorText != nil) ? self.style.fieldErrorColor.cgColor :  self.style.fieldBorderColor.cgColor ):  UIColor.white.cgColor
        textField.leftViewMode = data.isEditable ? .always : .never
        
        errorLabel.text = data.errorText
    }
    
    public override func prepareForReuse() {
        self.formattingPattern = nil
        textField.keyboardType = .default
        textField.autocapitalizationType = .none
        textField.placeholder = nil
        textField.text = nil
    }
    
    public func getTextField() -> UITextField {
        return textField
    }

}

extension FormTextFieldCell: UITextFieldDelegate {
    
    /** Determines if the textfield should return. */
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.formTextFieldCellShouldReturn(self, textField: textField) ?? false
    }
    
}
