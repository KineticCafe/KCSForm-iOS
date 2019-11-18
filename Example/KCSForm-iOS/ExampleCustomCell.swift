//
//  ExampleCustomCell.swift
//  KCSForm-iOS_Example
//
//  Created by Matthew Patience on 2019-03-02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import KCSForm_iOS

class ExampleCustomCell: FormCell {
    
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func update(title: String) {
        self.titleLabel.text = title
    }

}
