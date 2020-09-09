//
//  FormExtensions.swift
//  KCSForm-iOS
//
//  Created by Matthew Patience on 2019-02-24.
//

import UIKit

public extension String {
    
    func formatWithPattern(_ formattingPattern: String, replacementChar: Character) -> String? {
        
        // Remove any character that is not a number
        let numbersOnly = self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        
        var output = ""
        var stop = false
        
        var formatterIndex = formattingPattern.startIndex
        var sourceIndex = numbersOnly.startIndex
        
        while !stop {
            let formattingPatternRange = formatterIndex ..< formattingPattern.index(formatterIndex, offsetBy: 1)
            if formattingPattern[formattingPatternRange] != String(replacementChar) {
                output = output + formattingPattern[formattingPatternRange]
            } else if numbersOnly.count > 0 {
                
                let pureStringRange = sourceIndex ..< numbersOnly.index(sourceIndex, offsetBy: 1)
                
                output = output + numbersOnly[pureStringRange]
                
                sourceIndex = numbersOnly.index(after: sourceIndex)
                
            }
            
            formatterIndex = formattingPattern.index(after: formatterIndex)
            
            if formatterIndex >= formattingPattern.endIndex || sourceIndex >= numbersOnly.endIndex {
                stop = true
            }
        }
        return !output.isEmpty ? output : nil
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }

}
