//
//  FormDropdownCell.swift
//  Kiehls
//
//  Created by Steven Andrews on 2018-05-29.
//  Copyright © 2018 Kinetic Cafe. All rights reserved.
//

import UIKit
import DropDown

protocol FormDropdownCellDelegate {
    func formDropdownCell(_ cell: FormDropdownCell, selected index: Int)
}

public class FormDropdownCell: FormCell {
    
    public class Data: FormCellData {
        public var title: String?
        public var selection: Int?
        public var placeholder: String?
        public var isEditable: Bool
        public var stringOptions: [String]?
        public var colorOptions: [FormColor]?
        
        private init(title: String? = nil, selection: Int? = nil, placeholder: String? = nil, isEditable: Bool) {
            self.title = title
            self.selection = selection
            self.placeholder = placeholder
            self.isEditable = isEditable
        }
        
        public convenience init(title: String? = nil, selection: Int? = nil, placeholder: String? = nil, isEditable: Bool, options: [String]) {
            self.init(title: title, selection: selection, placeholder: placeholder, isEditable: isEditable)
            self.stringOptions = options
        }
        
        public convenience init(title: String? = nil, selection: Int? = nil, placeholder: String? = nil, isEditable: Bool, options: [FormColor]) {
            self.init(title: title, selection: selection, placeholder: placeholder, isEditable: isEditable)
            self.colorOptions = options
        }
    }

    //MARK: - IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var entryColorView: UIView!
    @IBOutlet var entryLabel: UILabel!
    @IBOutlet var entryView: UIView!
    @IBOutlet var indicatorImageView: UIImageView!
    @IBOutlet var textFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet var entryViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var entryViewTrailingConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    var delegate: FormDropdownCellDelegate?
    public var stringOptions: [String]?
    public var colorOptions: [FormColor]?
    public var selection: Int?
    fileprivate let dropDown = DropDown()
    fileprivate var isEditable = true
    
    //MARK: - Constants
    
    /* The text field horizontal inset */
    public static var textFieldInternalHorizontalInsets: CGFloat              = 10
    
    private lazy var underlineLayer: CALayer = {
        let underline = CALayer()
        underline.borderColor = self.style.fieldBorderColor.cgColor
        underline.frame = CGRect(x: 0, y: entryView.frame.size.height - self.style.fieldBorderWidth, width: entryView.frame.size.width, height: entryView.frame.size.height)
        underline.borderWidth = self.style.fieldBorderWidth
        return underline
    }()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
    }
    
    private func setupUI() {
        
        DropDown.startListeningToKeyboard()
        dropDown.anchorView = self.entryView
        dropDown.cellNib = UINib(nibName: "CustomDropDownCell", bundle: Bundle(for: FormViewController.self))
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? CustomDropDownCell else { return }
            if let colorOptions = self.colorOptions {
                cell.setColor(colorOptions[index])
            } else {
                cell.setString(item)
            }
        }
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.entryLabel.text = item
            self.entryLabel.textColor = self.style.fieldEntryColor
            if let colorOptions = self.colorOptions {
                self.entryColorView.backgroundColor = colorOptions[index].color
                self.entryColorView.isHidden = false
            }
            self.delegate?.formDropdownCell(self, selected: index)
        }
        self.dropDown.cancelAction = {
            self.dropDown.hide()
        }
    }
    
    internal override func updateStyle() {
        var dropdownImage: UIImage?
        if self.style.dropdownImage != nil {
            dropdownImage = self.style.dropdownImage
        } else {
            let bundle = Bundle(for: FormViewController.self)
            let bundleURL = bundle.resourceURL?.appendingPathComponent("Images.bundle")
            let resourceBundle = Bundle(url: bundleURL!)
            dropdownImage = UIImage(named: "ic_dropdown", in: resourceBundle, compatibleWith: nil)
        }
        self.indicatorImageView.image = dropdownImage?.withRenderingMode(.alwaysOriginal)
        self.indicatorImageView.tintColor = self.style.fieldBorderColor
        
        self.dropDown.textFont = self.style.dropdownFont
        self.dropDown.textColor = self.style.dropdownTextColor
        self.dropDown.selectedTextColor = self.style.dropdownTextColor
        
        self.entryView.layer.masksToBounds = true
        self.entryView.backgroundColor = .clear
        if self.selection == nil {
            self.entryLabel.textColor = self.style.fieldPlaceholderColor
        }
        self.entryLabel.font = self.style.fieldPlaceholderFont
        self.entryLabel.tintColor = self.style.fieldEntryColor
        self.entryColorView.layer.cornerRadius = self.style.colorOptionCornerRadius
        self.titleLabel.textColor = self.style.fieldTitleColor
        self.titleLabel.font = self.style.fieldTitleFont
        self.stackView.spacing = self.style.fieldTitleBottomMargin
        self.textFieldHeightConstraint.constant = FormTextFieldCell.textFieldHeight
        self.entryViewLeadingConstraint.constant = self.style.dropdownHorizontalMargins
        self.entryViewTrailingConstraint.constant = self.style.dropdownHorizontalMargins
        
        if isEditable {
            switch (self.style.textFieldStyle) {
            case .box:
                entryView.layer.cornerRadius = self.style.fieldCornerRadius
                entryView.layer.borderWidth = self.style.fieldBorderWidth
                entryView.layer.borderColor = self.style.fieldBorderColor.cgColor
                break
            case .underline:
                entryView.layer.addSublayer(underlineLayer)
                break
            case .none:
                removeBorders()
                break
            }
        } else {
            removeBorders()
        }
    }
    
    private func removeBorders() {
        underlineLayer.removeFromSuperlayer()
        entryView.layer.cornerRadius = 0
        entryView.layer.borderWidth = 0
        entryView.layer.borderColor = UIColor.clear.cgColor
    }
    
    public func update(_ data: Data) {
        
        isEditable = data.isEditable
        titleLabel.isHidden = (data.title == nil)
        titleLabel.text = data.title
        stringOptions = data.stringOptions
        colorOptions = data.colorOptions
        if let selection = data.selection {
            self.selection = selection
            if let colorOptions = self.colorOptions {
                entryColorView.isHidden = false
                entryColorView.backgroundColor = colorOptions[selection].color
                entryLabel.text = colorOptions[selection].name
            } else if let stringOptions = self.stringOptions {
                entryColorView.isHidden = true
                entryLabel.text = stringOptions[selection]
            }
            entryLabel.textColor = self.style.fieldEntryColor
        } else {
            if isEditable {
                entryLabel.text = data.placeholder
                entryLabel.textColor = self.style.fieldPlaceholderColor
            } else {
                entryLabel.text = ""
            }
            entryColorView.isHidden = true
        }
        self.dropDown.dataSource = stringOptions ??
            colorOptions?.map({ (formColor) -> String in (formColor.name ?? "")}) ?? []
        
        self.indicatorImageView.isHidden = !isEditable
        updateStyle()
        
    }
    
    @IBAction private func dropdownSelected(sender: Any) {
        if isEditable {
            self.dropDown.show()
        }
    }

}
