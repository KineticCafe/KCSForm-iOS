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

    }
    
    internal override func updateStyle() {
        self.titleLabel.textColor = self.style.sectionTitleColor
        self.titleLabel.font = self.style.sectionTitleFont
        
        self.topConstraint.constant = self.style.sectionTitleTopMargin
        self.bottomConstraint.constant = self.style.sectionTitleBottomMargin
    }

    public func update(_ data: Data) {
        titleLabel.text = data.title
    }
    
}
