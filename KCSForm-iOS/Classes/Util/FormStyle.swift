//
//  FormStyle.swift
//  KCSForm-iOS
//
//  Created by Matthew Patience on 2019-02-24.
//

import UIKit

public class FormStyle {
    
    internal static let shared = FormStyle()
    
    public init() {
        
    }
    
    
    // MARK: - Colors
    public var fieldTitleColor = UIColor.black
    public var fieldEntryColor = UIColor.black
    public var fieldPlaceholderColor = UIColor.black
    public var fieldBorderColor = UIColor.black
    public var fieldErrorColor = UIColor.black
    public var fieldDisabledColor = UIColor.black
    public var tagBorderColor = UIColor.black
    public var selectedColorOptionLabelColor = UIColor.black
    
    public var buttonLabelColor = UIColor.black
    public var buttonBorderColor = UIColor.black
    
    public var dropdownBackgroundColor = UIColor.clear
    public var dropdownTextColor = UIColor.black
    
    public var sectionTitleColor = UIColor.black
    public var titleColor = UIColor.black
    public var subTitleColor = UIColor.black
    
    public var formTint = UIColor.black
    
    
    // MARK: - Fonts
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
    public var titleFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var subTitleFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var checkboxFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var dropdownFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var tagFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var tagSelectedFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    public var selectedColorOptionFont: UIFont = {
        return .systemFont(ofSize: UIFont.systemFontSize)
    }()
    
    
    // MARK: - Sizes, Margins
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
    public var titleSubTitleTopMargin: CGFloat = 0
    public var titleSubTitleBottomMargin: CGFloat = 0
    public var titleSubTitleVerticalSpacing: CGFloat = 0
    public var errorTopMargin: CGFloat = 0
    public var dropdownCellHeight: CGFloat = 44
    public var dropdownHorizontalMargins: CGFloat = 10
    public var dropdownTextAlignment: NSTextAlignment = .natural
    public var buttonOptionHeight: CGFloat = 44
    public var buttonOptionHorizontalSpacing: CGFloat = 10
    public var tagInterItemSpacing: CGFloat = 10
    public var tagLineSpacing: CGFloat = 10
    public var tagPadding: CGFloat = 5
    public var tagCornerRadius: CGFloat = 0
    public var tagBorderWidth: CGFloat = 1
    public var tagHeight: CGFloat = 50
    public var colorOptionSize: CGFloat = 30
    public var colorOptionSpacing: CGFloat = 20
    public var colorOptionCornerRadius: CGFloat = 0
    
    // MARK: - Other
    public enum TextFieldStyle {
        case box
        case underline
        case none
    }
    public var textFieldStyle: TextFieldStyle = .box
    public var bounce: Bool = false
    public var passwordShowImage: UIImage? = nil
    public var passwordHideImage: UIImage? = nil
    public var dropdownImage: UIImage? = nil

}
