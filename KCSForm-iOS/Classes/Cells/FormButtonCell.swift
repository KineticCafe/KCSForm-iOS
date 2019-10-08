//
//  FormButtonCell.swift
//  Kiehls
//
//  Created by Matthew Patience on 2018-08-02.
//  Copyright © 2018 Kinetic Cafe. All rights reserved.
//

import UIKit

protocol FormButtonCellDelegate {
    
    func formButtonCellActionPressed(_ cell: FormButtonCell)
    
}

public class FormButtonCell: UICollectionViewCell, FormCell {
    
    @IBOutlet var button: FormButton!
    
    var delegate: FormButtonCellDelegate?
    
    public class Data: FormCellData {
        public var title: String
        public init(title: String) {
            self.title = title
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func update(_ data: Data) {
        button.setTitle(data.title, for: .normal)
    }
    
    @IBAction func buttonPressed(_ button: UIButton) {
        
        self.delegate?.formButtonCellActionPressed(self)
        
    }

}
