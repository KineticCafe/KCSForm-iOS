# KCSForm-iOS

KCS Form is a library to help you build iOS UI forms using pre-built input types. The SDK is easy to use and easy to style to make form creation effortless.

![alt text](https://github.com/KineticCafe/KCSForm-iOS/raw/master/Component-Images/kcs-forms-preview.png "FormViewController")

## Requirements

- iOS 11.0+
- Xcode 10.1+
- Swift 4.2+

## Author

Matthew Patience
- [Github](https://github.com/MatthewPatience)
- [LinkedIn](https://www.linkedin.com/in/matthewpatience/)
- [Kinetic Commerce](https://kineticcommerce.com/)

## Dependencies

These are already imported as pod dependancies, but thanks to the following libraries:

- [Dropdown](https://github.com/AssistoLab/DropDown)
- [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)

## Installation

[CocoaPods](https://cocoapods.org)

```ruby
pod 'KCSForm-iOS'
```

## Usage

Create an instance of FormViewController and implement it's delegate:

```swift
let formController = FormViewController()
formController.delegate = self
```

Stylise your form, by default the form has no margins, color, or fonts. Below are some of the available style options (See FormStyle class for all options), feel free to submit PRs to add more if required.

```swift
FormStyle.shared.fieldTitleColor = .black
FormStyle.shared.fieldEntryColor = .black
FormStyle.shared.fieldPlaceholderColor = .gray
FormStyle.shared.fieldBorderColor = .black
FormStyle.shared.fieldErrorColor = .red
FormStyle.shared.fieldDisabledColor = .gray
FormStyle.shared.buttonLabelColor = .black
FormStyle.shared.sectionTitleColor = .black
FormStyle.shared.titleColor = .black
FormStyle.shared.subTitleColor = .gray

FormStyle.shared.setFormMargins(leading: 20, trailing: 20, top: 20, bottom: 20)
FormStyle.shared.interItemFieldSpacing = 20
FormStyle.shared.lineSpacing = 20
FormStyle.shared.fieldTitleBottomMargin = 10
FormStyle.shared.sectionTitleTopMargin = 20
FormStyle.shared.sectionTitleBottomMargin = 0
FormStyle.shared.fieldCornerRadius = 2
FormStyle.shared.fieldBorderWidth = 1
FormStyle.shared.checkboxItemSpacing = 8
FormStyle.shared.titleSubTitleTopMargin = 20
FormStyle.shared.titleSubTitleBottomMargin = 10
FormStyle.shared.titleSubTitleVerticalSpacing = 10
FormStyle.shared.errorTopMargin = 5

FormStyle.shared.fieldTitleFont = UIFont.systemFont(ofSize: 14, weight: .medium)
FormStyle.shared.sectionTitleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
FormStyle.shared.fieldButtonFont = UIFont.systemFont(ofSize: 18, weight: .bold)
FormStyle.shared.titleFont = UIFont.systemFont(ofSize: 18, weight: .medium)
FormStyle.shared.subTitleFont = UIFont.systemFont(ofSize: 14, weight: .regular)
FormStyle.shared.fieldErrorFont = UIFont.systemFont(ofSize: 14, weight: .regular)

FormStyle.shared.textFieldStyle = .box
FormStyle.shared.bounce = false
```

Lastly, create the cells that will be in your form. Each cell will require a unique identifier, it is recommended that you use an enum to identify each cell.

```swift
enum CellId: Int {
    case firstName
    case lastName
    case email
    case phone
}
```

Each cell will require a specific data object that will define it's content and appearance. Width is measured in percentage of the overall width of each form row since the form uses a flow layout.

```swift
var cells = [FormViewController.Cell]()
let firstNameData = FormTextFieldCell.Data(title: "First Name", text: "", placeholder: "John", keyboardType: .default, returnKeyType: .next, formattingPattern: nil, capitalizationType: .words, isEditable: true, errorText: "Error!!!"))
cells.append(FormViewController.Cell(id: CellId.firstName.rawValue, type: .text, widthPercentage: 0.5, data: firstNameData)
formController.setCells(cells)
formController.reloadCollectionView()
```

Whenever the input content of a cell is changed, a FormViewControllerDelegate callback will be triggered depending on the cell type. For example, the updatedText callback would be triggered in the case of a FormTextFieldCell or FormPasswordCell text change.

```swift
func formViewController(_ controller: FormViewController, updatedText: String?, forCellId id: Int) {
    switch (id) {
    case CellId.firstName.rawValue:
        print(updatedText)
        break
    default:
        break
    }
}
```

## Available Form Components

### Section Title

![alt text](https://github.com/KineticCafe/KCSForm-iOS/raw/master/Component-Images/section-title.png "Section Title")

```swift
cells.append(FormViewController.Cell(id: CellId.section1.rawValue, type: .title, widthPercentage: 1.0,
    data: FormSectionTitleCell.Data(title: "Section One")))
```

### Text Field

![alt text](https://github.com/KineticCafe/KCSForm-iOS/raw/master/Component-Images/text-field.png "Text Field")

```swift
cells.append(FormViewController.Cell(id: CellId.email.rawValue, type: .text, widthPercentage: 1.0,
    data: FormTextFieldCell.Data(title: "Email", text: "", placeholder: "john@email.com", keyboardType: .emailAddress, returnKeyType: .next, formattingPattern: nil, capitalizationType: .none, isEditable: true, errorText: nil)))
```

### Password

![alt text](https://github.com/KineticCafe/KCSForm-iOS/raw/master/Component-Images/password.png "Password")

```swift
cells.append(FormViewController.Cell(id: CellId.password.rawValue, type: .password, widthPercentage: 1.0,
    data: FormPasswordCell.Data(title: "Password", password: "", placeholder: "********")))
```

### Button Options

![alt text](https://github.com/KineticCafe/KCSForm-iOS/raw/master/Component-Images/button-options.png "Button Options")

```swift
cells.append(FormViewController.Cell(id: CellId.gender.rawValue, type: .buttonOptions, widthPercentage: 1.0,
    data: FormButtonOptionsCell.Data(title: "Gender", multiSelect: false, options: ["Male", "Female", "Other"])))
```

### Tags

![alt text](https://github.com/KineticCafe/KCSForm-iOS/raw/master/Component-Images/tags.png "Tags")

```swift
cells.append(FormViewController.Cell(id: CellId.gender.rawValue, type: .buttonOptions, widthPercentage: 1.0,
    data: FormButtonOptionsCell.Data(title: "Gender", multiSelect: false, options: ["Male", "Female", "Other"])))
```

### Checkbox Options

![alt text](https://github.com/KineticCafe/KCSForm-iOS/raw/master/Component-Images/checkbox-options.png "Checkbox Options")

```swift
cells.append(FormViewController.Cell(id: CellId.contactOptions.rawValue, type: .checkboxOptions, widthPercentage: 1.0,
    data: FormCheckboxOptionsCell.Data(title: "Contact Methods", options: ["Phone", "Email", "Snail Mail", "Carrier Pidgeon"], optionStates: ["Phone": false, "Email": false])))
```

### Dropdown

![alt text](https://github.com/KineticCafe/KCSForm-iOS/raw/master/Component-Images/dropdown.png "Dropdown")

![alt text](https://github.com/KineticCafe/KCSForm-iOS/raw/master/Component-Images/dropdown-colors.png "Dropdown Colors")

```swift
cells.append(FormViewController.Cell(id: CellId.country.rawValue, type: .dropdown, widthPercentage: 1.0,
    data: FormDropdownCell.Data(title: "Country", selection: nil, placeholder: "Select a country", isEditable: true, options: ["Canada", "USA", "Mexico", "Westeros"])))
cells.append(FormViewController.Cell(id: CellId.eyeColor.rawValue, type: .dropdown, widthPercentage: 1.0,
    data: FormDropdownCell.Data(title: "Eye Color:", selection: nil, placeholder: "Select a color", isEditable: true, options: [FormColor(.blue, "Blue"), FormColor(.black, "Black"), FormColor(.brown, "Brown"), FormColor(.cyan, "Cyan"), FormColor(.gray, "Gray"), FormColor(.green, "Green", available: false), FormColor(.magenta, "Magenta"), FormColor(.orange, "Orange"), FormColor(.purple, "Purple")])))
```

### Label

![alt text](https://github.com/KineticCafe/KCSForm-iOS/raw/master/Component-Images/label.png "Label")

```swift
cells.append(FormViewController.Cell(id: CellId.someLabel.rawValue, type: .label, widthPercentage: 1.0,
    data: FormLabelCell.Data(text: NSAttributedString(string: "I am a label!"))))
```

### Title Subtitle

![alt text](https://github.com/KineticCafe/KCSForm-iOS/raw/master/Component-Images/title-subtitle.png "Title Subtitle")

```swift
cells.append(FormViewController.Cell(id: CellId.loremIpsum.rawValue, type: .titleSubtitle, widthPercentage: 1.0,
    data: FormTitleSubtitleCell.Data(title: "Lorem Ipsum", subTitle: "Lorem ipsum dolor sit amet")))
```

### Button

![alt text](https://github.com/KineticCafe/KCSForm-iOS/raw/master/Component-Images/button.png "Button")

```swift
cells.append(FormViewController.Cell(id: CellId.save.rawValue, type: .button, widthPercentage: 1.0,
    data: FormButtonCell.Data(title: "Save")))
```

### Color Options

![alt text](https://github.com/KineticCafe/KCSForm-iOS/raw/master/Component-Images/color-options.png "Color Options")

```swift
cells.append(FormViewController.Cell(id: CellId.favoriteColor.rawValue, type: .colorOptions, widthPercentage: 1.0,
    data: FormColorOptionsCell.Data(title: "Favorite Color:", multiSelect: false, selectedOptionIndex: nil, options: [FormColor(.blue, "Blue"), FormColor(.black, "Black"), FormColor(.brown, "Brown"), FormColor(.cyan, "Cyan"), FormColor(.gray, "Gray"), FormColor(.green, "Green", available: false), FormColor(.magenta, "Magenta"), FormColor(.orange, "Orange"), FormColor(.purple, "Purple")])))
```

### Spacer

```swift
cells.append(FormViewController.Cell(id: CellId.spacer.rawValue, type: .spacer, widthPercentage: 1.0, data: FormSpacerCell.Data(height: 20)))
```

### NEED SOMETHING CUSTOM?

No problem, just create your own collection view cell, set the cell type to "custom", and then tell it what class to use. (Note: Must be an XIB)

```swift
cells.append(FormViewController.Cell(id: <EXAMPLE_ID>, type: .custom, widthPercentage: 1.0, data: nil, customCell: ExampleCustomCell.self))
```

You will also need to implement the FormViewControllerDelegate updateCustomCell callback to update the cell's content when it is about to be displayed:

```swift
func formViewController(_ controller: FormViewController, updateCustomCell cell: UICollectionViewCell, forCellId id: Int) -> UICollectionViewCell {
    if id == CellId.optIn.rawValue {
        if let cell = cell as? ExampleCustomCell {
            cell.update(title: "Lorem ipsum")
        }
    }
    return cell
}
```

## License

This repository is licensed under the MIT License

https://opensource.org/licenses/MIT


## Community and Contributing

We welcome your contributions. Like all Kinetic Cafe open source projects, is under the Kinetic Cafe Open Source [Code of Conduct][kccoc].


[kccoc]: https://github.com/KineticCafe/code-of-conduct
