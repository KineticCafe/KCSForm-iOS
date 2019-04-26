//
//  FormButtonCell.swift
//
//  Created by Matthew Patience on 2018-08-02.
//  Copyright © 2018 Kinetic Cafe. All rights reserved.
//

import UIKit

protocol FormButtonCellDelegate {
    
    func formButtonCellActionPressed(_ cell: FormButtonCell)
    
}

public class FormButtonCell: UICollectionViewCell, FormCell {
    
    @IBOutlet public var button: FormButton!
    
    var delegate: FormButtonCellDelegate?
    
    public class Data: FormCellData {
        let title: String
        let underlined: Bool
        let normalColor: UIColor
        let highlightedColor: UIColor
        let backgroundColor: UIColor
        public init(title: String, underlined: Bool = false, normalColor: UIColor = .red, highlightedColor: UIColor = .red, backgroundColor: UIColor = .clear) {
            self.title = title
            self.underlined = underlined
            self.normalColor = normalColor
            self.highlightedColor = highlightedColor
            self.backgroundColor = backgroundColor
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func update(_ data: Data) {
        if data.underlined {
            
            button.setTitleColor(data.normalColor, for: .normal)
            button.setTitleColor(data.highlightedColor, for: .highlighted)
            button.backgroundColor = data.backgroundColor
            button.layer.borderColor = data.backgroundColor.cgColor
            
            let textFontAttributes = [
                .font: FormStyle.shared.fieldFormButtonCellFont,
                .foregroundColor: data.normalColor,
                .underlineStyle: 1,
                ] as [NSAttributedString.Key: Any]
            let title = NSAttributedString(string: data.title, attributes: textFontAttributes)
            button.setAttributedTitle(title, for: .normal)
            button.setIgnoreInverse(true)
            
        } else {
            button.setTitle(data.title, for: .normal)
        }
    }
    
    @IBAction func buttonPressed(_ button: UIButton) {
        
        self.delegate?.formButtonCellActionPressed(self)
        
    }
    
}

protocol FormButtonDelegate {
    func getButton() -> FormButton
    func setInverse(inverse: Bool)
}

extension FormButtonCell: FormButtonDelegate {
    public func getButton() -> FormButton {
        return button
    }
    public func setInverse(inverse: Bool = true) {
        button.setInverse(inverse)
    }
}
