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

public class FormDropdownCell: UICollectionViewCell, FormCell {
    
    public class Data: FormCellData {
        public var title: String?
        public var selection: String?
        public var placeholder: String?
        public var options: [String]
        
        public init(title: String? = nil, selection: String? = nil, placeholder: String? = nil, options: [String]) {
            self.title = title
            self.selection = selection
            self.placeholder = placeholder
            self.options = options
        }
    }

    //MARK: - IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet var entryLabel: UILabel!
    @IBOutlet var entryView: UIView!
    @IBOutlet var indicatorImageView: UIImageView!
    
    //MARK: - Properties
    var delegate: FormDropdownCellDelegate?
    public var options: [String]?
    fileprivate let dropDown = DropDown()
    
    //MARK: - Constants
    
    /* The text field horizontal inset */
    public static var textFieldInternalHorizontalInsets: CGFloat              = 10
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
    }
    
    private func setupUI() {
        
        self.titleLabel.textColor = FormStyle.shared.fieldTitleColor
        self.titleLabel.font = FormStyle.shared.fieldTitleFont
        self.titleBottomConstraint.constant = FormStyle.shared.fieldTitleBottomMargin
        
        let bundle = Bundle(for: FormViewController.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("Images.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        let dropdownImage = UIImage(named: "ic_dropdown", in: resourceBundle, compatibleWith: nil)
        self.indicatorImageView.image = dropdownImage?.withRenderingMode(.alwaysTemplate)
        self.indicatorImageView.tintColor = FormStyle.shared.fieldBorderColor
        
        entryView.backgroundColor = .white
        entryLabel.textColor = FormStyle.shared.fieldPlaceholderColor
        entryLabel.font = FormStyle.shared.fieldPlaceholderFont
        entryLabel.tintColor = FormStyle.shared.fieldEntryColor
        
        switch (FormStyle.shared.textFieldStyle) {
        case .box:
            entryView.layer.cornerRadius = FormStyle.shared.fieldCornerRadius
            entryView.layer.borderWidth = FormStyle.shared.fieldBorderWidth
            entryView.layer.borderColor = FormStyle.shared.fieldBorderColor.cgColor
            break
        case .underline:
            let border = CALayer()
            border.borderColor = FormStyle.shared.fieldBorderColor.cgColor
            border.frame = CGRect(x: 0, y: entryView.frame.size.height - FormStyle.shared.fieldBorderWidth, width: entryView.frame.size.width, height: entryView.frame.size.height)
            border.borderWidth = FormStyle.shared.fieldBorderWidth
            entryView.layer.addSublayer(border)
            entryView.layer.masksToBounds = true
            break
        }
        
        DropDown.startListeningToKeyboard()
        self.dropDown.anchorView = self.entryView
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.entryLabel.text = item
            self.entryLabel.textColor = FormStyle.shared.fieldEntryColor
            self.delegate?.formDropdownCell(self, selected: index)
        }
    }
    
    public func update(_ data: Data) {
        
        var title = data.title
        if title == nil || title?.count == 0 {
            title = " "
        }
        titleLabel.text = title
        if data.selection == nil || data.selection?.count == 0 {
            entryLabel.text = data.placeholder
            entryLabel.textColor = FormStyle.shared.fieldPlaceholderColor
        } else {
            entryLabel.text = data.selection
            entryLabel.textColor = FormStyle.shared.fieldEntryColor
        }
        options = data.options
        self.dropDown.dataSource = options ?? []
        
    }
    
    @IBAction private func dropdownSelected(sender: Any) {
        self.dropDown.show()
    }

}
