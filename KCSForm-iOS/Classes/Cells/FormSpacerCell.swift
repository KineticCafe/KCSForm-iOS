//
//  FormSpacerCell.swift
//  KCSForm-iOS
//
//  Created by Matthew Patience on 2019-10-08.
//

import UIKit

public class FormSpacerCell: UICollectionViewCell, FormCell {
    
    public class Data: FormCellData {
        public var height: CGFloat = 1
        public init(height: CGFloat) {
            self.height = height
        }
    }
    
    fileprivate var heightConstraint: NSLayoutConstraint?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func update(_ data: Data) {
        heightConstraint?.isActive = false
        heightConstraint = self.contentView.heightAnchor.constraint(equalToConstant: data.height)
    }

}
