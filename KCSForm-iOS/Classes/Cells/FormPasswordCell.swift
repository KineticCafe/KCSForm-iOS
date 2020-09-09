//
//  FormPasswordCell.swift
//  DropDown
//
//  Created by Matthew Patience on 2019-03-01.
//

import UIKit


protocol FormPasswordCellDelegate {
    
    /** Called when the specified textfield text did change. */
    func formPasswordCell(_ cell: FormPasswordCell, updatedText: String?)
    
    /** Determines if the textfield should return. */
    func formPasswordCellShouldReturn(_ cell: FormPasswordCell, textField: UITextField) -> Bool
    
}

public class FormPasswordCell: FormCell {
    
    public class Data: FormCellData {
        public var title: String
        public var password: String?
        public var placeholder: String?
        
        public init(title: String, password: String?, placeholder: String?) {
            self.title = title
            self.password = password
            self.placeholder = placeholder
        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var showHideImageView: UIImageView!
    @IBOutlet var stackView: UIStackView!
    
    var delegate: FormPasswordCellDelegate?
    private var showPassword = false
    
    private lazy var showImage: UIImage? = {
        if FormStyle.shared.passwordShowImage != nil {
            return FormStyle.shared.passwordShowImage?.withRenderingMode(.alwaysOriginal)
        }
        let bundle = Bundle(for: FormViewController.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("Images.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        return UIImage(named: "ic_show", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    }()
    
    private lazy var hideImage: UIImage? = {
        if FormStyle.shared.passwordHideImage != nil {
            return FormStyle.shared.passwordHideImage?.withRenderingMode(.alwaysOriginal)
        }
        let bundle = Bundle(for: FormViewController.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("Images.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        return UIImage(named: "ic_hide", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    }()
    
    private lazy var underlineLayer: CALayer = {
        let underline = CALayer()
        underline.borderColor = FormStyle.shared.fieldBorderColor.cgColor
        underline.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - FormStyle.shared.fieldBorderWidth, width: passwordTextField.frame.size.width, height: passwordTextField.frame.size.height)
        underline.borderWidth = FormStyle.shared.fieldBorderWidth
        return underline
    }()

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = FormStyle.shared.fieldTitleColor
        titleLabel.font = FormStyle.shared.fieldTitleFont
        passwordTextField.textColor = FormStyle.shared.fieldEntryColor
        passwordTextField.font = FormStyle.shared.fieldEntryFont
        passwordTextField.backgroundColor = .clear
        passwordTextField.addTarget(self, action: #selector(onTextChange), for: .editingChanged)
        passwordTextField.delegate = self
        passwordTextField.leftViewMode = .always
        passwordTextField.rightViewMode = .always
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        passwordTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        showHideImageView.tintColor = FormStyle.shared.fieldBorderColor
        showHideImageView.image = hideImage
        textFieldHeightConstraint.constant = FormTextFieldCell.textFieldHeight
        
        switch (FormStyle.shared.textFieldStyle) {
        case .box:
            passwordTextField.layer.cornerRadius = FormStyle.shared.fieldCornerRadius
            passwordTextField.layer.borderWidth = FormStyle.shared.fieldBorderWidth
            passwordTextField.layer.borderColor = FormStyle.shared.fieldBorderColor.cgColor
            break
        case .underline:
            passwordTextField.layer.addSublayer(underlineLayer)
            passwordTextField.layer.masksToBounds = true
            break
        case .none:
            underlineLayer.removeFromSuperlayer()
            passwordTextField.layer.cornerRadius = 0
            passwordTextField.layer.borderWidth = 0
            passwordTextField.layer.borderColor = UIColor.clear.cgColor
            break
        }
        
        stackView.spacing = FormStyle.shared.fieldTitleBottomMargin
        
    }
    
    public func update(_ data: Data) {
        self.titleLabel.text = data.title
        if let placeholder = data.placeholder {
            let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : FormStyle.shared.fieldPlaceholderColor])
            self.passwordTextField.attributedPlaceholder = attributedPlaceholder
        }
        self.passwordTextField.text = data.password
    }
    
    @IBAction private func showPassword(_ sender: UIButton) {
        showPassword = !showPassword
        passwordTextField.isSecureTextEntry = !showPassword
        showHideImageView.image = showPassword ? showImage : hideImage
    }
    
    @objc fileprivate func onTextChange() {
        delegate?.formPasswordCell(self, updatedText: passwordTextField.text)
    }

}

extension FormPasswordCell: UITextFieldDelegate {
    
    /** Determines if the textfield should return. */
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.formPasswordCellShouldReturn(self, textField: passwordTextField) ?? false
    }
    
}
