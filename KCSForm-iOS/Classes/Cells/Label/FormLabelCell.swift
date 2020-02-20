//
//  FormLabelCell.swift
//  Kiehls
//
//  Created by Steven Andrews on 2018-05-29.
//  Copyright © 2018 Kinetic Cafe. All rights reserved.
//

import UIKit
public class FormLabelCell: FormCell {
    
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
        
    }
    
    internal override func updateStyle() {
        text.textColor = self.style.fieldTitleColor
    }
    
    public func update(_ data: Data) {
        text.attributedText = data.text
    }

}
