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

public class FormPasswordCell: UICollectionViewCell, FormCell {
    
    public class Data: FormCellData {
        let title: String
        let password: String
        let placeholder: String?
        let maxlen: Int
        let height: CGFloat
        public init(title: String, password: String, placeholder: String?, maxlen: Int = 64, height: CGFloat = 44.0) {
            self.title = title
            self.password = password
            self.placeholder = placeholder
            self.maxlen = maxlen
            self.height = height
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showHideImageView: UIImageView!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    
    var delegate: FormPasswordCellDelegate?
    private var showPassword = false
    private var maxlen = 0
    
    private lazy var showImage: UIImage? = {
        let bundle = Bundle(for: FormViewController.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("Images.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        return UIImage(named: "ic_show", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    }()
    
    private lazy var hideImage: UIImage? = {
        let bundle = Bundle(for: FormViewController.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("Images.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        return UIImage(named: "ic_hide", in: resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
    }()

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = FormStyle.shared.fieldTitleColor
        titleLabel.font = FormStyle.shared.fieldTitleFont
        passwordTextField.textColor = FormStyle.shared.fieldEntryColor
        passwordTextField.font = FormStyle.shared.fieldEntryFont
        passwordTextField.backgroundColor = .white
        passwordTextField.addTarget(self, action: #selector(onTextChange), for: .editingChanged)
        passwordTextField.delegate = self
        passwordTextField.leftViewMode = .always
        passwordTextField.rightViewMode = .always
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        passwordTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        showHideImageView.tintColor = FormStyle.shared.fieldBorderColor
        showHideImageView.image = hideImage
        
        switch (FormStyle.shared.textFieldStyle) {
        case .box:
            containerView.layer.cornerRadius = FormStyle.shared.fieldCornerRadius
            containerView.layer.borderWidth = FormStyle.shared.fieldBorderWidth
            containerView.layer.borderColor = FormStyle.shared.fieldBorderColor.cgColor
            break
        case .underline:
            let border = CALayer()
            border.borderColor = FormStyle.shared.fieldBorderColor.cgColor
            border.frame = CGRect(x: 0, y: containerView.frame.size.height - FormStyle.shared.fieldBorderWidth, width: containerView.frame.size.width, height: containerView.frame.size.height)
            border.borderWidth = FormStyle.shared.fieldBorderWidth
            containerView.layer.addSublayer(border)
            containerView.layer.masksToBounds = true
            break
        }
        
        titleBottomConstraint.constant = FormStyle.shared.fieldTitleBottomMargin
        
    }
    
    public func update(_ data: Data) {
        var title = data.title
        if title.count == 0 {
            title = " "
        }
        self.titleLabel.text = title
        if let placeholder = data.placeholder {
            let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor : FormStyle.shared.fieldPlaceholderColor])
            self.passwordTextField.attributedPlaceholder = attributedPlaceholder
        }
        self.passwordTextField.text = data.password
        self.maxlen = data.maxlen
        self.containerViewHeightConstraint.constant = data.height
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
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < maxlen
    }
}
