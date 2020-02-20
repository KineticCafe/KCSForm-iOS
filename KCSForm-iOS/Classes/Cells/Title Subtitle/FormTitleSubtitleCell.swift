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
        
    }
    
    internal override func updateStyle() {
        titleLabel.textColor = self.style.titleColor
        subTitleLabel.textColor = self.style.subTitleColor
        titleLabel.font = self.style.titleFont
        subTitleLabel.font = self.style.subTitleFont
        stackView.spacing = self.style.titleSubTitleVerticalSpacing
    }
    
    public func update(_ data: Data) {
        self.titleLabel.isHidden = (data.title == nil)
        self.titleLabel.text = data.title
        self.subTitleLabel.isHidden = (data.subTitle == nil)
        self.subTitleLabel.text = data.subTitle
    }

}
