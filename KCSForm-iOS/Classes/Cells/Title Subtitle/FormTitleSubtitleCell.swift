//
//  FormTitleSubtitleCell.swift
//  DropDown
//
//  Created by Matthew Patience on 2019-02-28.
//

import UIKit

public class FormTitleSubtitleCell: FormCell {
    
    public class Data: FormCellData {
        public var title: String?
        public var subTitle: String?
        
        public init(title: String?, subTitle: String?) {
            self.title = title
            self.subTitle = subTitle
        }
    }

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = FormStyle.shared.titleColor
        subTitleLabel.textColor = FormStyle.shared.subTitleColor
        titleLabel.font = FormStyle.shared.titleFont
        subTitleLabel.font = FormStyle.shared.subTitleFont
        
        stackView.spacing = FormStyle.shared.titleSubTitleVerticalSpacing
    }
    
    public func update(_ data: Data) {
        self.titleLabel.isHidden = (data.title == nil)
        self.titleLabel.text = data.title
        self.subTitleLabel.isHidden = (data.subTitle == nil)
        self.subTitleLabel.text = data.subTitle
    }

}
