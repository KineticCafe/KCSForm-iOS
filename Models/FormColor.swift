//
//  FormColor.swift
//  DropDown
//
//  Created by Matthew Patience on 2020-02-19.
//

import UIKit

public class FormColor: NSObject {
    public var color: UIColor?
    public var name: String?
    public var available = true
    
    public override init() {}
    public init(_ color: UIColor?, _ name: String?, available: Bool = true) {
        self.color = color
        self.name = name
        self.available = available
    }
}
