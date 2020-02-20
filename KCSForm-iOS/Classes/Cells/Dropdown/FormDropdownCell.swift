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
        public var stringSelection: String?
        public var colorSelection: FormColor?
        public var placeholder: String?
        public var isEditable: Bool
        public var stringOptions: [String]?
        public var colorOptions: [FormColor]?
        
        public init(title: String? = nil, selection: String? = nil, placeholder: String? = nil, isEditable: Bool, options: [String]) {
            self.title = title
            self.stringSelection = selection
            self.placeholder = placeholder
            self.isEditable = isEditable
            self.stringOptions = options
        }
        
        public init(title: String? = nil, selection: FormColor? = nil, placeholder: String? = nil, isEditable: Bool, options: [FormColor]) {
            self.title = title
            self.colorSelection = selection
            self.placeholder = placeholder
            self.isEditable = isEditable
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
    
    //MARK: - Properties
    var delegate: FormDropdownCellDelegate?
    public var stringOptions: [String]?
    public var colorOptions: [FormColor]?
    fileprivate let dropDown = DropDown()
    fileprivate var isEditable = true
    
    //MARK: - Constants
    
    /* The text field horizontal inset */
    public static var textFieldInternalHorizontalInsets: CGFloat              = 10
    
    private lazy var underlineLayer: CALayer = {
        let underline = CALayer()
        underline.borderColor = FormStyle.shared.fieldBorderColor.cgColor
        underline.frame = CGRect(x: 0, y: entryView.frame.size.height - FormStyle.shared.fieldBorderWidth, width: entryView.frame.size.width, height: entryView.frame.size.height)
        underline.borderWidth = FormStyle.shared.fieldBorderWidth
        return underline
    }()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
    }
    
    private func setupUI() {
        
        self.titleLabel.textColor = FormStyle.shared.fieldTitleColor
        self.titleLabel.font = FormStyle.shared.fieldTitleFont
        self.stackView.spacing = FormStyle.shared.fieldTitleBottomMargin
        self.textFieldHeightConstraint.constant = FormTextFieldCell.textFieldHeight
        
        var dropdownImage: UIImage?
        if FormStyle.shared.dropdownImage != nil {
            dropdownImage = FormStyle.shared.dropdownImage
        } else {
            let bundle = Bundle(for: FormViewController.self)
            let bundleURL = bundle.resourceURL?.appendingPathComponent("Images.bundle")
            let resourceBundle = Bundle(url: bundleURL!)
            dropdownImage = UIImage(named: "ic_dropdown", in: resourceBundle, compatibleWith: nil)
        }
        self.indicatorImageView.image = dropdownImage?.withRenderingMode(.alwaysOriginal)
        self.indicatorImageView.tintColor = FormStyle.shared.fieldBorderColor
        
        entryView.layer.masksToBounds = true
        entryView.backgroundColor = .clear
        entryLabel.textColor = FormStyle.shared.fieldPlaceholderColor
        entryLabel.font = FormStyle.shared.fieldPlaceholderFont
        entryLabel.tintColor = FormStyle.shared.fieldEntryColor
        entryColorView.layer.cornerRadius = FormStyle.shared.colorOptionCornerRadius
        
        updateStyle()
        
        DropDown.startListeningToKeyboard()
        dropDown.anchorView = self.entryView
        dropDown.textFont = FormStyle.shared.dropdownFont
        dropDown.textColor = FormStyle.shared.dropdownTextColor
        dropDown.selectedTextColor = FormStyle.shared.dropdownTextColor
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
            self.entryLabel.textColor = FormStyle.shared.fieldEntryColor
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
    
    private func updateStyle() {
        if isEditable {
            switch (FormStyle.shared.textFieldStyle) {
            case .box:
                entryView.layer.cornerRadius = FormStyle.shared.fieldCornerRadius
                entryView.layer.borderWidth = FormStyle.shared.fieldBorderWidth
                entryView.layer.borderColor = FormStyle.shared.fieldBorderColor.cgColor
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
        if let selection = data.stringSelection {
            entryLabel.text = selection
            entryLabel.textColor = FormStyle.shared.fieldEntryColor
            entryColorView.isHidden = true
        } else if let selection = data.colorSelection {
            entryLabel.text = selection.name
            entryLabel.textColor = FormStyle.shared.fieldEntryColor
            entryColorView.backgroundColor = selection.color
            entryColorView.isHidden = false
        } else {
            if isEditable {
                entryLabel.text = data.placeholder
                entryLabel.textColor = FormStyle.shared.fieldPlaceholderColor
            } else {
                entryLabel.text = ""
            }
            entryColorView.isHidden = true
        }
        stringOptions = data.stringOptions
        colorOptions = data.colorOptions
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
