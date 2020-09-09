//
//  FormViewController.swift
//  Kiehls
//
//  Created by Matthew Patience on 2018-07-26.
//  Copyright © 2018 Kinetic Cafe. All rights reserved.
//

import UIKit

public protocol FormViewControllerDelegate {
    
    /** Called when a text entry input changed. */
    func formViewController(_ controller: FormViewController, updatedText: String?, forCellId id: Int)
    
    /** Called when an option is selected. */
    func formViewController(_ controller: FormViewController, selectedIndex: Int, forCellId id: Int)
    
    /** Called when a button is pressed. */
    func formViewController(_ controller: FormViewController, pressedButtonForCellId id: Int)
    
    /** Called when a checkbox is checked/unchecked. */
    func formViewController(_ controller: FormViewController, checked: Bool?, option: Int, forCellId id: Int)
    
    /** Called when a custom cell is about to be drawn and needs to be updated */
    func formViewController(_ controller: FormViewController, updateCustomCell cell: UICollectionViewCell, forCellId id: Int) -> UICollectionViewCell
    
}

public class FormViewController: UIViewController {
    
    public enum CellType {
        case title
        case titleSubtitle
        case label
        case button
        case text
        case buttonOptions
        case checkboxOptions
        case dropdown
        case password
        case spacer
        case tags
        case custom
    }
    
    public struct Cell {
        public var id: Int
        public var type: CellType
        public var widthPercentage: CGFloat
        public var data: FormCellData?
        public var customCell: FormCell.Type?
        public init(id: Int, type: CellType, widthPercentage: CGFloat, data: FormCellData?, customCell: FormCell.Type? = nil) {
            self.id = id
            self.type = type
            self.widthPercentage = widthPercentage
            self.data = data
            self.customCell = customCell
        }
    }
    
    fileprivate let collectionViewLayout = AlignCollectionViewFlowLayout()
    public lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.alwaysBounceVertical = false
        collectionView.bounces = FormStyle.shared.bounce
        collectionView.contentInset = UIEdgeInsets.init(top: 0,left: 0,bottom: 0,right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets.init(top: 0,left: 0,bottom: 0,right: 0)
        
        collectionView.register(UINib(nibName: FormTextFieldCell.nibName, bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormTextFieldCell.reuseIdentifier)
        collectionView.register(UINib(nibName: FormButtonOptionsCell.nibName, bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormButtonOptionsCell.reuseIdentifier)
        collectionView.register(UINib(nibName: FormCheckboxOptionsCell.nibName, bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormCheckboxOptionsCell.reuseIdentifier)
        collectionView.register(UINib(nibName: FormDropdownCell.nibName, bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormDropdownCell.reuseIdentifier)
        collectionView.register(UINib(nibName: FormSectionTitleCell.nibName, bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormSectionTitleCell.reuseIdentifier)
        collectionView.register(UINib(nibName: FormTitleSubtitleCell.nibName, bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormTitleSubtitleCell.reuseIdentifier)
        collectionView.register(UINib(nibName: FormLabelCell.nibName, bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormLabelCell.reuseIdentifier)
        collectionView.register(UINib(nibName: FormButtonCell.nibName, bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormButtonCell.reuseIdentifier)
        collectionView.register(UINib(nibName: FormPasswordCell.nibName, bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormPasswordCell.reuseIdentifier)
        collectionView.register(UINib(nibName: FormTagsCell.nibName, bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormTagsCell.reuseIdentifier)
        collectionView.register(UINib(nibName: FormSpacerCell.nibName, bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormSpacerCell.reuseIdentifier)
        
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        return collectionView
    }()
    
    
    //MARK: - Properties
    
    public var cells: [Cell]? {
        didSet {
            if let cells = cells {
                for cell in cells {
                    if cell.type == .custom {
                        if let customCell = cell.customCell {
                            self.collectionView.register(UINib(nibName: customCell.nibName, bundle: Bundle.init(for: customCell)), forCellWithReuseIdentifier: customCell.reuseIdentifier)
                        }
                    }
                }
            }
            reloadCollectionView()
        }
    }
    public var delegate: FormViewControllerDelegate?
    
    
    //MARK: - Lifecycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear
        view.addSubview(collectionView)
        setUpConstraints()
        
    }
    
    
    //MARK: - Public Functions
    
    public func reloadCollectionView() {
        self.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
    }
    
    
    //MARK: - Private Functions
    
    fileprivate func setUpConstraints() {
        
        if #available(iOS 11.0, *) {
            let safeArea = self.view.safeAreaLayoutGuide
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
        } else {
            let topGuide = self.topLayoutGuide
            collectionView.topAnchor.constraint(equalTo: topGuide.bottomAnchor, constant: 0).isActive = true
        }
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
    }
    
    public func getConfiguredCell(cellTemplate: FormViewController.Cell, collectionView: UICollectionView, indexPath: IndexPath, sizingOnly: Bool) -> UICollectionViewCell {
        switch cellTemplate.type {
        case .title:
            var cell: FormSectionTitleCell?
            if sizingOnly {
                cell = FormSectionTitleCell.nib.instantiate(withOwner: self, options: nil).first as? FormSectionTitleCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormSectionTitleCell.reuseIdentifier, for: indexPath) as? FormSectionTitleCell
            }
            if let cell = cell, let data = cellTemplate.data as? FormSectionTitleCell.Data {
                cell.update(data)
            }
            return cell ?? UICollectionViewCell()
        case .titleSubtitle:
            var cell: FormTitleSubtitleCell?
            if sizingOnly {
                cell = FormTitleSubtitleCell.nib.instantiate(withOwner: self, options: nil).first as? FormTitleSubtitleCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormTitleSubtitleCell.reuseIdentifier, for: indexPath) as? FormTitleSubtitleCell
            }
            if let cell = cell, let data = cellTemplate.data as? FormTitleSubtitleCell.Data {
                cell.update(data)
            }
            return cell ?? UICollectionViewCell()
        case .text:
            var cell: FormTextFieldCell?
            if sizingOnly {
                cell = FormTextFieldCell.nib.instantiate(withOwner: self, options: nil).first as? FormTextFieldCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormTextFieldCell.reuseIdentifier, for: indexPath) as? FormTextFieldCell
                cell?.delegate = self
            }
            if let cell = cell, let data = cellTemplate.data as? FormTextFieldCell.Data {
                cell.update(data)
            }
            return cell ?? UICollectionViewCell()
        case .buttonOptions:
            var cell: FormButtonOptionsCell?
            if sizingOnly {
                cell = FormButtonOptionsCell.nib.instantiate(withOwner: self, options: nil).first as? FormButtonOptionsCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormButtonOptionsCell.reuseIdentifier, for: indexPath) as? FormButtonOptionsCell
                cell?.delegate = self
            }
            if let cell = cell, let data = cellTemplate.data as? FormButtonOptionsCell.Data {
                cell.update(data)
            }
            return cell ?? UICollectionViewCell()
        case .dropdown:
            var cell: FormDropdownCell?
            if sizingOnly {
                cell = FormDropdownCell.nib.instantiate(withOwner: self, options: nil).first as? FormDropdownCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormDropdownCell.reuseIdentifier, for: indexPath) as? FormDropdownCell
                cell?.delegate = self
            }
            if let cell = cell, let data = cellTemplate.data as? FormDropdownCell.Data {
                cell.update(data)
            }
            return cell ?? UICollectionViewCell()
        case .label:
            var cell: FormLabelCell?
            if sizingOnly {
                cell = FormLabelCell.nib.instantiate(withOwner: self, options: nil).first as? FormLabelCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormLabelCell.reuseIdentifier, for: indexPath) as? FormLabelCell
            }
            if let cell = cell, let data = cellTemplate.data as? FormLabelCell.Data {
                cell.update(data)
            }
            return cell ?? UICollectionViewCell()
        case .button:
            var cell: FormButtonCell?
            if sizingOnly {
                cell = FormButtonCell.nib.instantiate(withOwner: self, options: nil).first as? FormButtonCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormButtonCell.reuseIdentifier, for: indexPath) as? FormButtonCell
                cell?.delegate = self
            }
            if let cell = cell, let data = cellTemplate.data as? FormButtonCell.Data {
                cell.update(data)
            }
            return cell ?? UICollectionViewCell()
        case .checkboxOptions:
            var cell: FormCheckboxOptionsCell?
            if sizingOnly {
                cell = FormCheckboxOptionsCell.nib.instantiate(withOwner: self, options: nil).first as? FormCheckboxOptionsCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCheckboxOptionsCell.reuseIdentifier, for: indexPath) as? FormCheckboxOptionsCell
                cell?.delegate = self
            }
            if let cell = cell, let data = cellTemplate.data as? FormCheckboxOptionsCell.Data {
                cell.update(data)
            }
            return cell ?? UICollectionViewCell()
        case .password:
            var cell: FormPasswordCell?
            if sizingOnly {
                cell = FormPasswordCell.nib.instantiate(withOwner: self, options: nil).first as? FormPasswordCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormPasswordCell.reuseIdentifier, for: indexPath) as? FormPasswordCell
                cell?.delegate = self
            }
            if let cell = cell, let data = cellTemplate.data as? FormPasswordCell.Data {
                cell.update(data)
            }
            return cell ?? UICollectionViewCell()
        case .spacer:
            var cell: FormSpacerCell?
            if sizingOnly {
                cell = FormSpacerCell.nib.instantiate(withOwner: self, options: nil).first as? FormSpacerCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormSpacerCell.reuseIdentifier, for: indexPath) as? FormSpacerCell
            }
            if let cell = cell, let data = cellTemplate.data as? FormSpacerCell.Data {
                cell.update(data)
            }
            return cell ?? UICollectionViewCell()
        case .tags:
            var cell: FormTagsCell?
            if sizingOnly {
                cell = FormTagsCell.nib.instantiate(withOwner: self, options: nil).first as? FormTagsCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormTagsCell.reuseIdentifier, for: indexPath) as? FormTagsCell
                cell?.delegate = self
            }
            if let cell = cell, let data = cellTemplate.data as? FormTagsCell.Data {
                cell.update(data)
            }
            return cell ?? UICollectionViewCell()
        case .custom:
            if let customCell = cellTemplate.customCell {
                var cell: UICollectionViewCell?
                if sizingOnly, let customCell = cellTemplate.customCell {
                    cell = customCell.nib.instantiate(withOwner: self, options: nil).first as? UICollectionViewCell
                } else {
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: customCell), for: indexPath)
                }
                if let customCell = cell {
                    cell = self.delegate?.formViewController(self, updateCustomCell: customCell, forCellId: cellTemplate.id) ?? UICollectionViewCell()
                }
                return cell ?? UICollectionViewCell()
            }
        }
        return UICollectionViewCell()
    }

}

extension FormViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cells = cells else {
            return CGSize(width: 0, height: 0)
        }
        let cell = cells[indexPath.row]
        
        let rowItemCount = getRowItemCountForIndex(indexPath)
        let margins = FormStyle.shared.leadingMargin + FormStyle.shared.trailingMargin
        let totalInteritemSpacing = (FormStyle.shared.interItemFieldSpacing)*CGFloat(rowItemCount-1)
        let availableWidth = collectionView.frame.size.width - margins - totalInteritemSpacing
        let width = cell.widthPercentage * availableWidth
        let size = calculateDynamicCellHeight(cellTemplate: cell, width: width, collectionView: collectionView, indexPath: indexPath)
        return CGSize(width: floor(width), height: size.height)
    }

    private func calculateDynamicCellHeight(cellTemplate: FormViewController.Cell, width: CGFloat, collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        let sizingCell = getConfiguredCell(cellTemplate: cellTemplate, collectionView: collectionView, indexPath: indexPath, sizingOnly: true)
        sizingCell.frame = CGRect(x: 0, y: 0, width: width, height: 0)
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        let size = sizingCell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size
    }
    
    private func getRowItemCountForIndex(_ indexPath: IndexPath) -> Int {
        guard let cells = cells else {
            return 0
        }
        var currentRowWidth: CGFloat = 0
        var currentRowItemCount: Int = 0
        var insideTargetRow = false
        for (index, element) in cells.enumerated() {
            if indexPath.row == index {
                insideTargetRow = true
            }
            currentRowItemCount += 1
            currentRowWidth += element.widthPercentage
            
            if index == (cells.count-1) && insideTargetRow {
                return currentRowItemCount
            } else if (currentRowWidth + cells[index+1].widthPercentage) > 1.0 {
                if insideTargetRow {
                    return currentRowItemCount
                }
                currentRowWidth = 0
                currentRowItemCount = 0
            }
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return FormStyle.shared.interItemFieldSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return FormStyle.shared.lineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: FormStyle.shared.topMargin, left: FormStyle.shared.leadingMargin, bottom: FormStyle.shared.bottomMargin, right: FormStyle.shared.trailingMargin)
    }
    
}

extension FormViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let cells = cells {
            return cells.count
        }
        
        return 0
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cells = cells else {
            return UICollectionViewCell()
        }
        let cellTemplate = cells[indexPath.row]
        let cell = getConfiguredCell(cellTemplate: cellTemplate, collectionView: collectionView, indexPath: indexPath, sizingOnly: false)
        cell.layoutIfNeeded()
        return cell
    }
}


//MARK: - Text Field

extension FormViewController: FormTextFieldCellDelegate {
    
    func formTextFieldCell(_ cell: FormTextFieldCell, updatedText: String?) {
        
        let indexPath = collectionView.indexPath(for: cell)
        guard let row = indexPath?.row, let cells = cells else {
            return
        }
        let masterCell = cells[row]
        if let data = masterCell.data as? FormTextFieldCell.Data {
            data.text = updatedText
        }
        delegate?.formViewController(self, updatedText: updatedText, forCellId: masterCell.id)
        
    }
    
    public func formTextFieldCellShouldReturn(_ cell: FormTextFieldCell, textField: UITextField) -> Bool {
        guard let cells = cells, let indexPath = collectionView.indexPath(for: cell) else {
            textField.resignFirstResponder()
            return false
        }
        for row in (indexPath.row+1)..<cells.count {
            if let theCell = collectionView.cellForItem(at: IndexPath.init(row: row, section: indexPath.section)) as? FormTextFieldCell {
                theCell.getTextField().becomeFirstResponder()
                return false
            }
            
        }
        textField.resignFirstResponder()
        return false
    }
}


//MARK: - Button Options

extension FormViewController: FormButtonOptionsCellDelegate {
    
    func formButtonOptionsCell(_ cell: FormButtonOptionsCell, selectedOptionIndex: Int) {
        
        let indexPath = collectionView.indexPath(for: cell)
        guard let row = indexPath?.row, let cells = cells else {
            return
        }
        let masterCell = cells[row]
        if let data = masterCell.data as? FormButtonOptionsCell.Data {
            data.selectedOptions = cell.selectedOptions
        }
        delegate?.formViewController(self, selectedIndex: selectedOptionIndex, forCellId: masterCell.id)
        
    }
    
}


//MARK: - Picker

extension FormViewController: FormDropdownCellDelegate {
    
    func formDropdownCell(_ cell: FormDropdownCell, selected index: Int) {
        
        let indexPath = collectionView.indexPath(for: cell)
        guard let row = indexPath?.row, let cells = cells else {
            return
        }
        let masterCell = cells[row]
        if let data = masterCell.data as? FormDropdownCell.Data {
            data.selection = cell.options?[index]
        }
        delegate?.formViewController(self, selectedIndex: index, forCellId: masterCell.id)
        
    }
    
}


//MARK: - Button

extension FormViewController: FormButtonCellDelegate {
    
    func formButtonCellActionPressed(_ cell: FormButtonCell) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let row = indexPath?.row, let cells = cells else {
            return
        }
        let masterCell = cells[row]
        delegate?.formViewController(self, pressedButtonForCellId: masterCell.id)
    }
    
}


//MARK: - Checkbox Options

extension FormViewController: FormCheckboxOptionsCellDelegate {
    
    func formCheckboxOptionsCell(_ cell: FormCheckboxOptionsCell, checked: Bool, forIndex: Int) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let row = indexPath?.row, let cells = cells else {
            return
        }
        let masterCell = cells[row]
        if let data = masterCell.data as? FormCheckboxOptionsCell.Data, let value = cell.options?[forIndex] {
            data.optionStates[value] = checked
        }
        delegate?.formViewController(self, checked: checked, option: forIndex, forCellId: masterCell.id)
    }
    
}


// MARK: - Password

extension FormViewController: FormPasswordCellDelegate {
    
    func formPasswordCell(_ cell: FormPasswordCell, updatedText: String?) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let row = indexPath?.row, let cells = cells else {
            return
        }
        let masterCell = cells[row]
        if let data = masterCell.data as? FormPasswordCell.Data {
            data.password = updatedText
        }
        delegate?.formViewController(self, updatedText: updatedText, forCellId: masterCell.id)
    }
    
    func formPasswordCellShouldReturn(_ cell: FormPasswordCell, textField: UITextField) -> Bool {
        guard let cells = cells, let indexPath = collectionView.indexPath(for: cell) else {
            textField.resignFirstResponder()
            return false
        }
        for row in (indexPath.row+1)..<cells.count {
            if let theCell = collectionView.cellForItem(at: IndexPath.init(row: row, section: indexPath.section)) as? FormTextFieldCell {
                theCell.getTextField().becomeFirstResponder()
                return false
            }
            
        }
        textField.resignFirstResponder()
        return false
    }
    
}

extension FormViewController: FormTagsCellDelegate {
    
    func formTagsCell(_ cell: FormTagsCell, selectedOptionIndex: Int) {
        let indexPath = collectionView.indexPath(for: cell)
        guard let row = indexPath?.row, let cells = cells else {
            return
        }
        let masterCell = cells[row]
        if let data = masterCell.data as? FormTagsCell.Data {
            data.selectedOptions = cell.selectedOptions
        }
        delegate?.formViewController(self, selectedIndex: selectedOptionIndex, forCellId: masterCell.id)
    }
    
}
