//
//  BasicViewController.swift
//  KCSForm-iOS_Example
//
//  Created by Matthew Patience on 2019-03-02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import KCSForm_iOS

class BasicViewController: UIViewController {

    enum CellId: Int {
        case section1
        case colors
        case firstName
        case lastName
        case loremIpsum
        case email
        case phone
        case country
        case postalCode
        case gender
        case section2
        case interests
        case contactOptions
        case favoriteColor
        case eyeColor
        case password
        case optIn
        case someLabel
        case save
    }
    
    let formController = FormViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Basic"
        
        view.addSubview(formController.view)
        formController.delegate = self
        NSLayoutConstraint.activate([
            formController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            formController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            formController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            formController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        setFormStyle()
        
        formController.cells = createTestCells()
        formController.reloadCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setFormStyle() {
        let style = FormStyle()
        style.fieldTitleColor = .black
        style.fieldEntryColor = .black
        style.fieldPlaceholderColor = .gray
        style.fieldBorderColor = .black
        style.fieldErrorColor = .red
        style.fieldDisabledColor = .gray
        style.buttonLabelColor = .black
        style.buttonBorderColor = .black
        style.sectionTitleColor = .black
        style.titleColor = .black
        style.subTitleColor = .gray
        style.dropdownBackgroundColor = UIColor.white
        style.dropdownTextColor = UIColor.black
        
        style.setFormMargins(leading: 20, trailing: 20, top: 20, bottom: 20)
        style.interItemFieldSpacing = 20
        style.lineSpacing = 20
        style.fieldTitleBottomMargin = 10
        style.sectionTitleTopMargin = 20
        style.sectionTitleBottomMargin = 0
        style.fieldCornerRadius = 2
        style.fieldBorderWidth = 1
        style.checkboxItemSpacing = 8
        style.titleSubTitleTopMargin = 20
        style.titleSubTitleBottomMargin = 10
        style.titleSubTitleVerticalSpacing = 10
        style.errorTopMargin = 5
        style.dropdownTextAlignment = .natural
        style.tagInterItemSpacing = 10
        style.tagLineSpacing = 10
        style.tagPadding = 20
        style.tagCornerRadius = 10
        style.tagBorderWidth = 1
        style.tagHeight = 30
        style.colorOptionCornerRadius = 2
        
        style.fieldTitleFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        style.sectionTitleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        style.fieldButtonFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        style.titleFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        style.subTitleFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        style.fieldErrorFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        style.dropdownFont = .systemFont(ofSize: UIFont.systemFontSize)
        style.tagSelectedFont = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .bold)
        
        style.textFieldStyle = .box
        style.bounce = false
        
        formController.setStyle(style)
    }
    
    private func createTestCells() -> [FormViewController.Cell] {
        var cells = [FormViewController.Cell]()
        cells.append(FormViewController.Cell(id: CellId.section1.rawValue, type: .title, widthPercentage: 1.0,
                                             data: FormSectionTitleCell.Data(title: "Section One")))
        cells.append(FormViewController.Cell(id: CellId.firstName.rawValue, type: .text, widthPercentage: 0.5,
                                             data: FormTextFieldCell.Data(title: "First Name", text: "", placeholder: "John", keyboardType: .default, returnKeyType: .next, formattingPattern: nil, capitalizationType: .words, isEditable: true, errorText: "Error!!!")))
        cells.append(FormViewController.Cell(id: CellId.lastName.rawValue, type: .text, widthPercentage: 0.5,
                                             data: FormTextFieldCell.Data(title: "Last Name", text: "", placeholder: "Smith", keyboardType: .default, returnKeyType: .next, formattingPattern: nil, capitalizationType: .words, isEditable: true, errorText: nil)))
        cells.append(FormViewController.Cell(id: CellId.email.rawValue, type: .text, widthPercentage: 1.0,
                                             data: FormTextFieldCell.Data(title: "Email", text: "", placeholder: "john@email.com", keyboardType: .emailAddress, returnKeyType: .next, formattingPattern: nil, capitalizationType: .none, isEditable: true, errorText: nil)))
        cells.append(FormViewController.Cell(id: CellId.loremIpsum.rawValue, type: .titleSubtitle, widthPercentage: 1.0,
                                             data: FormTitleSubtitleCell.Data(title: "Lorem Ipsum", subTitle: "Lorem ipsum dolor sit amet")))
        cells.append(FormViewController.Cell(id: CellId.phone.rawValue, type: .text, widthPercentage: 1.0,
                                             data: FormTextFieldCell.Data(title: "Phone", text: "", placeholder: "(416) 123-1234", keyboardType: .phonePad, returnKeyType: .next, formattingPattern: "(***) ***-****", capitalizationType: .none, isEditable: true, errorText: nil)))
        cells.append(FormViewController.Cell(id: CellId.country.rawValue, type: .dropdown, widthPercentage: 1.0,
                                             data: FormDropdownCell.Data(title: "Country", selection: nil, placeholder: "Select a country", isEditable: true, options: ["Canada", "USA", "Mexico", "Westeros"])))
        cells.append(FormViewController.Cell(id: CellId.postalCode.rawValue, type: .text, widthPercentage: 0.5,
                                             data: FormTextFieldCell.Data(title: "Postal Code", text: "", placeholder: "A1A 1A1", keyboardType: .default, returnKeyType: .next, formattingPattern:"*** ***", capitalizationType: .allCharacters, isEditable: true, errorText: nil)))
        cells.append(FormViewController.Cell(id: CellId.gender.rawValue, type: .buttonOptions, widthPercentage: 1.0,
                                             data: FormButtonOptionsCell.Data(title: "Gender", multiSelect: false, options: ["Male", "Female", "Other"])))
        cells.append(FormViewController.Cell(id: CellId.section2.rawValue, type: .title, widthPercentage: 1.0,
                                             data: FormSectionTitleCell.Data(title: "Section Two")))
        cells.append(FormViewController.Cell(id: CellId.interests.rawValue, type: .tags, widthPercentage: 1.0,
                                             data: FormTagsCell.Data(title: "Interests", multiSelect: true, dynamicSize: true, selectedOptionIndex: nil, options: ["Biking", "Skiing", "Running", "Origami", "Sitting", "Walking Aimlessly"])))
        cells.append(FormViewController.Cell(id: CellId.contactOptions.rawValue, type: .checkboxOptions, widthPercentage: 1.0,
                                             data: FormCheckboxOptionsCell.Data(title: "Contact Methods", options: ["Phone", "Email", "Snail Mail", "Carrier Pidgeon"], optionStates: ["Phone": false, "Email": false])))
        cells.append(FormViewController.Cell(id: CellId.password.rawValue, type: .password, widthPercentage: 1.0,
                                             data: FormPasswordCell.Data(title: "Password", password: "", placeholder: "********")))
        cells.append(FormViewController.Cell(id: CellId.favoriteColor.rawValue, type: .colorOptions, widthPercentage: 1.0,
                                             data: FormColorOptionsCell.Data(title: "Favorite Color:", multiSelect: false, selectedOptionIndex: nil, options: [FormColor(.blue, "Blue"), FormColor(.black, "Black"), FormColor(.brown, "Brown"), FormColor(.cyan, "Cyan"), FormColor(.gray, "Gray"), FormColor(.green, "Green", available: false), FormColor(.magenta, "Magenta"), FormColor(.orange, "Orange"), FormColor(.purple, "Purple")])))
        cells.append(FormViewController.Cell(id: CellId.eyeColor.rawValue, type: .dropdown, widthPercentage: 1.0,
                                             data: FormDropdownCell.Data(title: "Eye Color:", selection: nil, placeholder: "Select a color", isEditable: true, options: [FormColor(.blue, "Blue"), FormColor(.black, "Black"), FormColor(.brown, "Brown"), FormColor(.cyan, "Cyan"), FormColor(.gray, "Gray"), FormColor(.green, "Green", available: false), FormColor(.magenta, "Magenta"), FormColor(.orange, "Orange"), FormColor(.purple, "Purple")])))
        cells.append(FormViewController.Cell(id: CellId.optIn.rawValue, type: .custom, widthPercentage: 1.0, data: nil, customCell: ExampleCustomCell.self))
        cells.append(FormViewController.Cell(id: CellId.someLabel.rawValue, type: .label, widthPercentage: 1.0,
                                             data: FormLabelCell.Data(text: NSAttributedString(string: "I am a label!"))))
        cells.append(FormViewController.Cell(id: CellId.save.rawValue, type: .button, widthPercentage: 1.0,
                                             data: FormButtonCell.Data(title: "Save")))
        return cells
    }
    
}

extension BasicViewController: FormViewControllerDelegate {
    
    func formViewController(_ controller: FormViewController, updatedText: String?, forCellId id: Int) {
        
        guard let updatedText = updatedText else {
            return
        }
        
        switch (id) {
        case CellId.firstName.rawValue:
            print(updatedText)
            break
        case CellId.lastName.rawValue:
            print(updatedText)
            break
        case CellId.email.rawValue:
            print(updatedText)
            break
        case CellId.phone.rawValue:
            print(updatedText)
            break
        case CellId.password.rawValue:
            print(updatedText)
            break
        default:
            break
        }
        
    }
    
    func formViewController(_ controller: FormViewController, selectedIndex: Int, forCellId id: Int) {
        
        switch (id) {
        case CellId.country.rawValue:
            print(selectedIndex)
            break
        case CellId.gender.rawValue:
            print(selectedIndex)
            break
        case CellId.favoriteColor.rawValue:
            print(selectedIndex)
            break
        case CellId.eyeColor.rawValue:
            print(selectedIndex)
            break
        case CellId.interests.rawValue:
            print(selectedIndex)
            break
        default:
            break
        }
        
    }
    
    func formViewController(_ controller: FormViewController, pressedButtonForCellId id: Int) {
        switch (id) {
        case CellId.save.rawValue:
            print("Save was pressed")
            break
        default:
            break
        }
    }
    
    func formViewController(_ controller: FormViewController, checked: Bool?, option: Int, forCellId id: Int) {
        
        switch (id) {
        case CellId.contactOptions.rawValue:
            print(option)
            break
        default:
            break
        }
        
    }
    
    func formViewController(_ controller: FormViewController, updateCustomCell cell: UICollectionViewCell, forCellId id: Int) -> UICollectionViewCell {
        
        if id == CellId.optIn.rawValue {
            if let cell = cell as? ExampleCustomCell {
                cell.update(title: "Lorem ipsum")
            }
        }
        
        return cell
    }
    
}
