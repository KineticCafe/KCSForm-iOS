//
//  FormLabelCell.swift
//  Kiehls
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
    @IBOutlet var text: UILabel!
    
    //MARK: - Functions
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        text.textColor = FormStyle.shared.fieldTitleColor
        
    }
    
    public func update(_ data: Data) {
        text.attributedText = data.text
    }

}
