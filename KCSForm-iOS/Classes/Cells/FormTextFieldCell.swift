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

public class FormTextFieldCell: UICollectionViewCell, FormCell {
    
    public class Data: FormCellData {
        let title: String?
        let text: String?
        let placeholder: String?
        let keyboardType: UIKeyboardType
        let returnKeyType: UIReturnKeyType
        let formattingPattern: String?
        let capitalizationType: UITextAutocapitalizationType
        let isEditable: Bool
        let errorText: String?

        
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
    @IBOutlet var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var textFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var errorTopMarginConstraint: NSLayoutConstraint!
    
    //MARK: - Constants
    
    /* The text field horizontal inset */
    public static var textFieldInternalHorizontalInsets: CGFloat              = 10
    
    public static var textFieldHeight: CGFloat                                = 44
    
    //Properties
    var delegate: FormTextFieldCellDelegate?
    
    /** Optional formatting pattern to be used for the cell. */
    fileprivate var formattingPattern: String?
    
    public static func getErrorHeight() -> CGFloat {
        return 31
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        
        self.titleLabel.textColor = FormStyle.shared.fieldTitleColor
        self.titleLabel.font = FormStyle.shared.fieldTitleFont
        self.titleBottomConstraint.constant = FormStyle.shared.fieldTitleBottomMargin
        
        textField.addTarget(self, action: #selector(onTextChange), for: .editingChanged)
        textField.delegate = self
        textField.backgroundColor = .white
        textField.textColor = FormStyle.shared.fieldEntryColor
        textField.tintColor = FormStyle.shared.formTint
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: FormTextFieldCell.textFieldInternalHorizontalInsets, height: 0))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: FormTextFieldCell.textFieldInternalHorizontalInsets, height: 0))
        textField.font = FormStyle.shared.fieldEntryFont
        textFieldHeightConstraint.constant = FormTextFieldCell.textFieldHeight
        
        switch (FormStyle.shared.textFieldStyle) {
        case .box:
            textField.layer.cornerRadius = FormStyle.shared.fieldCornerRadius
            textField.layer.borderWidth = FormStyle.shared.fieldBorderWidth
            textField.layer.borderColor = FormStyle.shared.fieldBorderColor.cgColor
            break
        case .underline:
            let border = CALayer()
            border.borderColor = FormStyle.shared.fieldBorderColor.cgColor
            border.frame = CGRect(x: 0, y: textField.frame.size.height - FormStyle.shared.fieldBorderWidth, width: textField.frame.size.width, height: textField.frame.size.height)
            border.borderWidth = FormStyle.shared.fieldBorderWidth
            textField.layer.addSublayer(border)
            textField.layer.masksToBounds = true
            break
        }
        
        errorLabel.textColor = FormStyle.shared.fieldErrorColor
        errorLabel.font = FormStyle.shared.fieldErrorFont
        errorTopMarginConstraint.constant = FormStyle.shared.errorTopMargin
    }
    
    @objc fileprivate func onTextChange() {
        if let formattingPattern = formattingPattern, let replacementText = textField.text, !replacementText.isEmpty {
            textField.text = replacementText.formatWithPattern(formattingPattern, replacementChar: "*".first!)
        }
        
        delegate?.formTextFieldCell(self, updatedText: textField.text)
    }
    
    /* Public update function */
    public func update(_ data: Data) {
        
        var title = data.title
        if title == nil || title?.count == 0 {
            title = " "
        }
        titleLabel.text = title
        textField.text = data.text
        
        if let placeholder = data.placeholder {
            let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor : FormStyle.shared.fieldPlaceholderColor])
            textField.attributedPlaceholder = attributedPlaceholder
        }
        textField.keyboardType = data.keyboardType
        textField.autocapitalizationType = data.capitalizationType
        textField.returnKeyType = data.returnKeyType
        
        self.formattingPattern = data.formattingPattern
        
        textField.isUserInteractionEnabled = data.isEditable
        textField.layer.borderColor =  data.isEditable ? ((data.errorText != nil) ? FormStyle.shared.fieldErrorColor.cgColor :  FormStyle.shared.fieldBorderColor.cgColor ):  UIColor.white.cgColor
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
