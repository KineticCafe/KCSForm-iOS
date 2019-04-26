//
//  FormStyle.swift
//  KCSForm-iOS
//
//  Created by Matthew Patience on 2019-02-24.
//

import UIKit

public class FormStyle: NSObject {
    
    public static let shared = FormStyle()
    
    
    // -- FIELDS --
    
    //Colors
    public var fieldTitleColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public var fieldEntryColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public var fieldPlaceholderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public var fieldBorderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public var fieldBodyColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public var fieldErrorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public var fieldDisabledColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    public var buttonLabelColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    public var sectionTitleColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public var titleColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    public var subTitleColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    
    //Fonts
    public var fieldTitleFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var fieldEntryFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var fieldPlaceholderFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var fieldErrorFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var buttonLabelFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var sectionTitleFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var fieldButtonFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var fieldFormButtonCellFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var titleFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var subTitleFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var checkboxFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    
    //Labels
    public var adjustsFontSizeToFitWidth = true
    public var lineBreakMode: NSLineBreakMode = .byWordWrapping
    public var numberOfLines = 0
    public var minimumScaleFactor:CGFloat = 0.5

    //Sizes, Margins
    public var leadingMargin: CGFloat = 0
    public var trailingMargin: CGFloat = 0
    public var topMargin: CGFloat = 0
    public var bottomMargin: CGFloat = 0
    public func setFormMargins(leading: CGFloat, trailing: CGFloat, top: CGFloat, bottom: CGFloat) {
        leadingMargin = leading; trailingMargin = trailing; topMargin = top; bottomMargin = bottom;
    }
    
    public var interItemFieldSpacing: CGFloat = 0
    public var lineSpacing: CGFloat = 1
    public var fieldCornerRadius: CGFloat = 0
    public var fieldBorderWidth: CGFloat = 1
    public var fieldTitleBottomMargin: CGFloat = 0
    public var sectionTitleTopMargin: CGFloat = 0
    public var sectionTitleBottomMargin: CGFloat = 0
    public var checkboxItemSpacing: CGFloat = 0
    public var checkboxBottomMargin: CGFloat = 0
    public var switchOptionItemSpacing: CGFloat = 0
    public var titleSubTitleTopMargin: CGFloat = 0
    public var titleSubTitleBottomMargin: CGFloat = 0
    public var titleSubTitleVerticalSpacing: CGFloat = 0
    public var errorTopMargin: CGFloat = 0
    
    public enum TextFieldStyle {
        case box
        case underline
    }
    public var textFieldStyle: TextFieldStyle = .box
    public var bounce: Bool = false
    
    private override init() {
        
    }

}
