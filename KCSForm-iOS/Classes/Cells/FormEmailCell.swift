//
//  FormEmailCell.swift
//  KCSForm-iOS
//
//  Created by Mauricio Esteves on 2019-03-05.
//

import UIKit

@objc protocol FormEmailCellValidationDelegate {
    @objc optional func formEmailCellValidation(sender cell: FormEmailCell, feedBackHandler: @escaping (Bool, String?)->Void)
    @objc optional func formEmailCellFailedValidation(sender cell: FormEmailCell)

}

protocol FormEmailCellDelegate: FormEmailCellValidationDelegate {
    
    /** Called when the specified textfield text did change. */
    func formEmailCell(_ cell: FormEmailCell, updatedText: String?)
    
    /** Determines if the textfield should return. */
    func formEmailCellShouldReturn(_ cell: FormEmailCell, textField: UITextField) -> Bool
    
}

public class FormEmailCell: UICollectionViewCell, FormCell {
    
    public static var activityIndicatorDefaultColour = UIColor(red: 228 / 255, green: 231 / 255, blue: 232 / 255, alpha: 1)
    
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
        let errorTextOther: String?
        let imageName: String?
        let hasEmailError: Bool
        
        public init(title: String? = nil, text: String? = nil, placeholder: String? = nil, keyboardType: UIKeyboardType = .emailAddress, returnKeyType: UIReturnKeyType = .next, formattingPattern: String? = nil, capitalizationType: UITextAutocapitalizationType = .none, isEditable:Bool = true, hasEmailError: Bool = false, errorText:String? = nil, errorTextOther: String? = nil, imageName: String?) {
            self.title = title
            self.text = text
            self.placeholder = placeholder
            self.keyboardType = keyboardType
            self.returnKeyType = returnKeyType
            self.formattingPattern = formattingPattern
            self.capitalizationType = capitalizationType
            self.isEditable = isEditable
            self.hasEmailError = hasEmailError
            self.errorText = errorText
            self.errorTextOther = errorTextOther
            self.imageName = imageName
        }
    }
    
    //IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var validationView: UIView!
    
    fileprivate var data: Data?
    fileprivate var errorText: String?
    fileprivate var errorTextOther: String?
    fileprivate var hasEmailError: Bool!
    
    /** The image view. */
    public let emailCheckImageView: UIImageView = {
        
        let imageView                                       = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let activityIndicator: UIActivityIndicatorView = {
        
        let activityIndicator    = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.color  = FormEmailCell.activityIndicatorDefaultColour
        
        return activityIndicator
    }()
    
    //MARK: - Constants
    
    /* The text field horizontal inset */
    public static var textFieldInternalHorizontalInsets: CGFloat              = 10
    
    public static var textFieldHeight: CGFloat                                = 44
    
    //Properties
    var delegate: FormEmailCellDelegate?
    
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
        
        self.validationView.backgroundColor = .white
        self.titleLabel.textColor = FormStyle.shared.fieldTitleColor
        self.titleLabel.font = FormStyle.shared.fieldTitleFont
        self.titleBottomConstraint.constant = FormStyle.shared.fieldTitleBottomMargin
        
        textField.addTarget(self, action: #selector(onTextChange), for: .editingChanged)
        textField.delegate = self
        textField.backgroundColor = .white
        textField.textColor = FormStyle.shared.fieldEntryColor
        textField.tintColor = FormStyle.shared.fieldEntryColor
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: FormEmailCell.textFieldInternalHorizontalInsets, height: 0))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: FormEmailCell.textFieldInternalHorizontalInsets, height: 0))
        textField.font = FormStyle.shared.fieldEntryFont
        textFieldHeightConstraint.constant = FormEmailCell.textFieldHeight
        
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
        addActivityIndicator()
    }
    
    @objc fileprivate func onTextChange() {
        if let formattingPattern = formattingPattern, let replacementText = textField.text, !replacementText.isEmpty {
            textField.text = replacementText.formatWithPattern(formattingPattern, replacementChar: "*".first!)
        }
        
        delegate?.formEmailCell(self, updatedText: textField.text)
        performValidation()
    }
    
    /* Public update function */
    public func update(_ data: Data) {
        self.data = data
        
        if let imageName = data.imageName {
            emailCheckImageView.image = UIImage(named: imageName)
        }
        
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
        
        formattingPattern = data.formattingPattern
        hasEmailError = data.hasEmailError
        errorLabel.text = nil
        
        errorText = data.errorText
        errorTextOther = data.errorTextOther
        
        self.errorLabel.heightAnchor.constraint(equalToConstant: 16.5).isActive = hasEmailError
        
        if let text = textField.text, !text.isEmpty && hasEmailError {
            textField.becomeFirstResponder()
            performValidation()
        }
        
    }
    
    private func addValidCheckImageField(_ result: Bool) {
        
        if result {
            emailCheckImageView.isHidden = true
            activityIndicator.stopAnimating()
            if emailCheckImageView.superview == nil {
                validationView.addSubview(emailCheckImageView)
                NSLayoutConstraint.activate([
                    emailCheckImageView.trailingAnchor.constraint(equalTo: validationView.trailingAnchor),
                    emailCheckImageView.leadingAnchor.constraint(equalTo: validationView.leadingAnchor),
                    emailCheckImageView.topAnchor.constraint(equalTo: validationView.topAnchor),
                    emailCheckImageView.bottomAnchor.constraint(equalTo: validationView.bottomAnchor),
                    ])
            }
        }
    }
    
    public override func prepareForReuse() {
        self.formattingPattern = nil
        textField.keyboardType = .default
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.placeholder = nil
        textField.text = nil
    }
    
    public func getTextField() -> UITextField {
        return textField
    }
    
}

extension FormEmailCell: UITextFieldDelegate {
    
    /** Determines if the textfield should return. */
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.formEmailCellShouldReturn(self, textField: textField) ?? false
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
        
        return true
    }
    
    fileprivate func performValidation() {
        guard let text = textField.text else { return }

        if text.isValidEmail {
            delegate?.formEmailCellValidation?(sender: self, feedBackHandler: { [weak self] available, _ in

                self?.addValidCheckImageField(available)
                self?.emailCheckImageView.isHidden = !available
                self?.activityIndicator.stopAnimating()
                self?.errorLabel.isHidden = available
                self?.errorLabel.text = self?.errorText
                
                self?.textField.layer.borderColor =  (self?.errorText != nil && !available ) ? FormStyle.shared.fieldErrorColor.cgColor :  FormStyle.shared.fieldBorderColor.cgColor
                self?.textField.textColor    =  (self?.errorText != nil && !available) ? FormStyle.shared.fieldErrorColor :  FormStyle.shared.fieldEntryColor

                self?.errorLabel?.layoutIfNeeded()
            })
        } else {
            
            self.addValidCheckImageField(true)
            self.emailCheckImageView.isHidden = true
            
            self.errorLabel.text = errorTextOther
            self.errorLabel.isHidden = !(errorTextOther != nil && !text.isEmpty)
            textField.layer.borderColor =  (errorTextOther != nil && !text.isEmpty) ? FormStyle.shared.fieldErrorColor.cgColor :  FormStyle.shared.fieldBorderColor.cgColor
            textField.textColor    =  (errorTextOther != nil && !text.isEmpty) ? FormStyle.shared.fieldErrorColor :  FormStyle.shared.fieldEntryColor
            
            self.errorLabel.layoutIfNeeded()
            delegate?.formEmailCellFailedValidation?(sender: self)
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        performValidation()
    }
    
    private func addActivityIndicator() {
        if activityIndicator.superview == nil {
            validationView.addSubview(activityIndicator)
            activityIndicator.hidesWhenStopped = true
            
            NSLayoutConstraint.activate([
                activityIndicator.trailingAnchor.constraint(equalTo: validationView.trailingAnchor),
                activityIndicator.leadingAnchor.constraint(equalTo: validationView.leadingAnchor),
                activityIndicator.topAnchor.constraint(equalTo: validationView.topAnchor),
                activityIndicator.bottomAnchor.constraint(equalTo: validationView.bottomAnchor),
                ])
        }
    }
}
