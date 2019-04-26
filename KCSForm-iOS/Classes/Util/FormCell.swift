//
//  FormCell.swift
//  KCSForm-iOS
//
//  Created by Matthew Patience on 2019-02-24.
//

import UIKit

protocol FormCell {
    
}

extension FormCell {
    
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
    
}
