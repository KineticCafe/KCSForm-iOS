//
//  FormSectionTitleCell.swift
//  Kiehls
//
//  Created by Steven Andrews on 2018-05-29.
//  Copyright © 2018 Kinetic Cafe. All rights reserved.
//

import UIKit

public class FormSectionTitleCell: FormCell {
    
    public class Data: FormCellData {
        public var title: String
        public init(title: String) {
            self.title = title
        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    override public func awakeFromNib() {
        super.awakeFromNib()

        self.titleLabel.textColor = FormStyle.shared.sectionTitleColor
        self.titleLabel.font = FormStyle.shared.sectionTitleFont
        
        self.topConstraint.constant = FormStyle.shared.sectionTitleTopMargin
        self.bottomConstraint.constant = FormStyle.shared.sectionTitleBottomMargin
    }

    public func update(_ data: Data) {
        titleLabel.text = data.title
    }
    
}
