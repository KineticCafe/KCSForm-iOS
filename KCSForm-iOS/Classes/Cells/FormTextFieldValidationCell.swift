//
//  FormTextFieldCell.swift
//  Kiehls
//
//  Created by Steven Andrews on 2018-05-28.
//  Copyright © 2018 Kinetic Cafe. All rights reserved.
//

import UIKit

@objc protocol FormTextFieldOptionalValidationDelegate {
    @objc optional func formTextFieldCellValidation(_ cell: FormTextFieldValidationCell, validationSuccess: Bool, externalMessage: Bool)
}

protocol FormTextFieldValidationCellDelegate: FormTextFieldOptionalValidationDelegate {
    
    /** Called when the specified textfield text did change. */
    func formTextFieldCell(_ cell: FormTextFieldValidationCell, updatedText: String?)
    
    /** Determines if the textfield should return. */
    func formTextFieldCellShouldReturn(_ cell: FormTextFieldValidationCell, textField: UITextField) -> Bool
    
}

public class FormTextFieldValidationCell: UICollectionViewCell, FormCell {
    
    public enum FormattingType {
        
        case `default`
        case phone
        case postal
        case custom(String)
        
        var pattern: String? {
            switch self {
            case .`default`:
                return nil
            case .phone:
                return "(***) ***-****"
            case .postal:
                return "*** ***"
            case .custom(let format):
                return format
            }
        }
    }
    
    public class Data: FormCellData {
        let title: String?
        let text: String?
        let placeholder: String?
        let keyboardType: UIKeyboardType
        let returnKeyType: UIReturnKeyType
        let formattingPattern: FormattingType?
        let capitalizationType: UITextAutocapitalizationType
        let isEditable: Bool
        let errorText: String?
        let validationSuccess: Bool
        let externalMessage: Bool
        
        public init(title: String? = nil, text: String? = nil, placeholder: String? = nil, keyboardType: UIKeyboardType = .default, returnKeyType: UIReturnKeyType = .next, formattingPattern: FormattingType? = .default, capitalizationType: UITextAutocapitalizationType = .none, isEditable:Bool = true, errorText:String? = nil, validationSuccess: Bool = true, externalMessage: Bool = false) {
            self.title = title
            self.text = text
            self.placeholder = placeholder
            self.keyboardType = keyboardType
            self.returnKeyType = returnKeyType
            self.formattingPattern = formattingPattern
            self.capitalizationType = capitalizationType
            self.isEditable = isEditable
            self.errorText = errorText
            self.validationSuccess = validationSuccess
            self.externalMessage = externalMessage
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
    var delegate: FormTextFieldValidationCellDelegate?
    
    /** Optional formatting pattern to be used for the cell. */
    fileprivate var formattingPattern: FormattingType?
    fileprivate var validationSuccess: Bool!
    fileprivate var externalMessage: Bool!
    public private(set) var externalText: String!

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
        self.titleLabel.numberOfLines = FormStyle.shared.numberOfLines
        self.titleLabel.adjustsFontSizeToFitWidth = FormStyle.shared.adjustsFontSizeToFitWidth
        self.titleLabel.lineBreakMode = FormStyle.shared.lineBreakMode
        self.titleLabel.minimumScaleFactor = FormStyle.shared.minimumScaleFactor

        self.titleBottomConstraint.constant = FormStyle.shared.fieldTitleBottomMargin
        
        textField.addTarget(self, action: #selector(onTextChange), for: .editingChanged)
        textField.delegate = self
        textField.backgroundColor = .white
        textField.textColor = FormStyle.shared.fieldEntryColor
        textField.tintColor = FormStyle.shared.fieldEntryColor
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
    
    fileprivate func checkSuccess(_ text: String, _ validationSuccess: inout Bool) {
        if text.count == 0, let placeholder = textField.placeholder {
            delegate?.formTextFieldCellValidation?(self, validationSuccess: placeholder.isValidCanadianPostalCode, externalMessage: externalMessage)
            validationSuccess = placeholder.isValidCanadianPostalCode
        } else {
            delegate?.formTextFieldCellValidation?(self, validationSuccess: text.isValidCanadianPostalCode, externalMessage: externalMessage)
            validationSuccess = text.isValidCanadianPostalCode
        }
    }
    
    fileprivate func validatePostalCode(exited: Bool = false) {
        if let formattingPattern = formattingPattern, case .postal = formattingPattern {
            guard let text = textField.text, text.count == 7 || text.count == 0 else {
                if let text = textField.text, exited {
                    var validationSuccess = true
                    checkSuccess(text, &validationSuccess)
                    textField.layer.borderColor =  !validationSuccess ? FormStyle.shared.fieldErrorColor.cgColor :  FormStyle.shared.fieldBorderColor.cgColor
                }
                return
                
            }
            var validationSuccess = true
            checkSuccess(text, &validationSuccess)
            textField.layer.borderColor =  !validationSuccess ? FormStyle.shared.fieldErrorColor.cgColor :  FormStyle.shared.fieldBorderColor.cgColor

            errorLabel.layoutIfNeeded()
            titleLabel.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func onTextChange() {
        if let formattingPattern = formattingPattern, let pattern = formattingPattern.pattern, let replacementText = textField.text, !replacementText.isEmpty {
            textField.text = replacementText.formatWithPattern(pattern, replacementChar: "*".first!)
        }
        validatePostalCode()
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
        validationSuccess = data.validationSuccess
        externalMessage = data.externalMessage
        
        textField.isUserInteractionEnabled = data.isEditable
        
        if let pattern = data.formattingPattern, case .postal = pattern {
            
            if data.text == nil  && data.placeholder != nil {
                // fall back to the place holder text for postal code until user input is supplied
                validationSuccess = data.placeholder?.isValidCanadianPostalCode
            }
            
            textField.layer.borderColor =  data.isEditable ? ((data.errorText != nil && !validationSuccess) ? FormStyle.shared.fieldErrorColor.cgColor :  FormStyle.shared.fieldBorderColor.cgColor ):  UIColor.white.cgColor
        } else {
            textField.layer.borderColor =  data.isEditable ? ((data.errorText != nil && !validationSuccess) ? FormStyle.shared.fieldErrorColor.cgColor :  FormStyle.shared.fieldBorderColor.cgColor ):  UIColor.white.cgColor
        }
        
        textField.leftViewMode = data.isEditable ? .always : .never

        errorLabel.isHidden = validationSuccess
        errorLabel.heightAnchor.constraint(equalToConstant: 16.5).isActive = !validationSuccess
        errorLabel.text = nil
        externalText = data.errorText

        if let pattern = data.formattingPattern, case .postal = pattern {
            if let text = textField.text, !text.isEmpty && !validationSuccess{
                errorLabel.text = externalMessage ? nil : data.errorText
                textField.becomeFirstResponder()
            }
        }
        textField.layoutIfNeeded()
        errorLabel.layoutIfNeeded()
    }
    
    public override func prepareForReuse() {
        self.formattingPattern = nil
        textField.keyboardType = .default
        textField.autocapitalizationType = .none
        textField.placeholder = nil
        textField.text = nil
        errorLabel.text = nil
    }
    
    public func getTextField() -> UITextField {
        return textField
    }
}

extension FormTextFieldValidationCell: UITextFieldDelegate {
    
    /** Determines if the textfield should return. */
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validatePostalCode(exited: true)
        return delegate?.formTextFieldCellShouldReturn(self, textField: textField) ?? false
    }
 
    public func textFieldDidEndEditing(_ textField: UITextField) {
        validatePostalCode(exited: true)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        validatePostalCode()
        return true
    }
}
