//
//  FormCell.swift
//  KCSForm-iOS
//
//  Created by Matthew Patience on 2019-02-24.
//

import UIKit

open class FormCell: UICollectionViewCell {
    
    public var style: FormStyle = FormStyle.shared {
        didSet {
            updateStyle()
        }
    }
    
    internal func updateStyle() {
        preconditionFailure("This method must be overriden")
    }
    
    public static var nibName: String {
        return String(describing: self)
    }
    
    public static var nib: UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: nibName, bundle: bundle)
    }
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
