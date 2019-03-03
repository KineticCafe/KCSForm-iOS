//
//  FormTitleSubtitleCell.swift
//  DropDown
//
//  Created by Matthew Patience on 2019-02-28.
//

import UIKit

public class FormTitleSubtitleCell: UICollectionViewCell, FormCell {
    
    public class Data: FormCellData {
        let title: String
        let subTitle: String
        
        public init(title: String, subTitle: String) {
            self.title = title
            self.subTitle = subTitle
        }
    }

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var topMargin: NSLayoutConstraint!
    @IBOutlet var bottomMargin: NSLayoutConstraint!
    @IBOutlet var verticalMargin: NSLayoutConstraint!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = FormStyle.shared.titleColor
        subTitleLabel.textColor = FormStyle.shared.subTitleColor
        titleLabel.font = FormStyle.shared.titleFont
        subTitleLabel.font = FormStyle.shared.subTitleFont
        
        topMargin.constant = FormStyle.shared.titleSubTitleTopMargin
        bottomMargin.constant = FormStyle.shared.titleSubTitleBottomMargin
        verticalMargin.constant = FormStyle.shared.titleSubTitleVerticalSpacing
    }
    
    public func update(_ data: Data) {
        self.titleLabel.text = data.title
        self.subTitleLabel.text = data.subTitle
    }

}
