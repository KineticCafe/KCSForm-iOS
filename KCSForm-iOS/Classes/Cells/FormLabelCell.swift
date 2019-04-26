//
//  FormLabelCell.swift
//
//  Created by Steven Andrews on 2018-05-29.
//  Copyright © 2018 Kinetic Cafe. All rights reserved.
//

import UIKit
public class FormLabelCell: UICollectionViewCell, FormCell {
    
    public class Data: FormCellData {
        public var text: NSAttributedString
        
        public init(text: NSAttributedString) {
            self.text = text
        }
    }

    //MARK: - IBOutlets
    @IBOutlet public var text: UILabel!
    
    //MARK: - Functions
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        text.textColor = FormStyle.shared.fieldTitleColor
        text.numberOfLines = FormStyle.shared.numberOfLines
        text.adjustsFontSizeToFitWidth = FormStyle.shared.adjustsFontSizeToFitWidth
        text.lineBreakMode = FormStyle.shared.lineBreakMode

    }
    
    public func update(_ data: Data) {
        text.attributedText = data.text
    }

}

public protocol FormLabelDelegate {
    func text(hide label: Bool)
}

extension FormLabelCell: FormLabelDelegate {
    public func text(hide label: Bool) {
        text.isHidden = label
    }
}
