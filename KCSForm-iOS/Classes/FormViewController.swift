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
        case custom
    }
    
    public struct Cell {
        let id: Int
        let type: CellType
        let widthPercentage: CGFloat
        let data: FormCellData?
        let customCell: AnyClass?
        public init(id: Int, type: CellType, widthPercentage: CGFloat, data: FormCellData?, customCell: AnyClass? = nil) {
            self.id = id
            self.type = type
            self.widthPercentage = widthPercentage
            self.data = data
            self.customCell = customCell
        }
    }
    
    fileprivate let collectionViewLayout = AlignCollectionViewFlowLayout()
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.alwaysBounceVertical = false
        collectionView.bounces = FormStyle.shared.bounce
        collectionView.contentInset = UIEdgeInsetsMake(0,0,0,0)
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0,0,0,0)
        
        
        collectionView.register(UINib(nibName: FormTextFieldCell.reuseIdentifier(), bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormTextFieldCell.reuseIdentifier())
        collectionView.register(UINib(nibName: FormButtonOptionsCell.reuseIdentifier(), bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormButtonOptionsCell.reuseIdentifier())
        collectionView.register(UINib(nibName: FormCheckboxOptionsCell.reuseIdentifier(), bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormCheckboxOptionsCell.reuseIdentifier())
        collectionView.register(UINib(nibName: FormDropdownCell.reuseIdentifier(), bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormDropdownCell.reuseIdentifier())
        collectionView.register(UINib(nibName: FormSectionTitleCell.reuseIdentifier(), bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormSectionTitleCell.reuseIdentifier())
        collectionView.register(UINib(nibName: FormTitleSubtitleCell.reuseIdentifier(), bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormTitleSubtitleCell.reuseIdentifier())
        collectionView.register(UINib(nibName: FormLabelCell.reuseIdentifier(), bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormLabelCell.reuseIdentifier())
        collectionView.register(UINib(nibName: FormButtonCell.reuseIdentifier(), bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormButtonCell.reuseIdentifier())
        collectionView.register(UINib(nibName: FormPasswordCell.reuseIdentifier(), bundle: Bundle.init(for: FormViewController.self)), forCellWithReuseIdentifier: FormPasswordCell.reuseIdentifier())
        
        if #available(iOS 11, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        return collectionView
    }()
    
    
    //MARK: - Properties
    
    fileprivate var cells: [Cell]?
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
    
    public func setCells(_ cells: [Cell]!) {
        
        self.cells = cells
        for cell in cells {
            if cell.type == .custom {
                if let customCell = cell.customCell {
                    self.collectionView.register(UINib(nibName: String(describing: customCell), bundle: Bundle.init(for: customCell)), forCellWithReuseIdentifier:String(describing: customCell))
                }
            }
        }
        
    }
    
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
    
    fileprivate func getConfiguredCell(cellTemplate: FormViewController.Cell, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        switch cellTemplate.type {
        case .title:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormSectionTitleCell.reuseIdentifier(), for: indexPath) as? FormSectionTitleCell {
                if let data = cellTemplate.data as? FormSectionTitleCell.Data {
                    cell.update(data)
                }
                return cell
            }
        case .titleSubtitle:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormTitleSubtitleCell.reuseIdentifier(), for: indexPath) as? FormTitleSubtitleCell {
                if let data = cellTemplate.data as? FormTitleSubtitleCell.Data {
                    cell.update(data)
                }
                return cell
            }
        case .text:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormTextFieldCell.reuseIdentifier(), for: indexPath as IndexPath) as? FormTextFieldCell {
                cell.delegate = self
                if let data = cellTemplate.data as? FormTextFieldCell.Data {
                    cell.update(data)
                }
                return cell
            }
        case .buttonOptions:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormButtonOptionsCell.reuseIdentifier(), for: indexPath as IndexPath) as? FormButtonOptionsCell {
                cell.delegate = self
                if let data = cellTemplate.data as? FormButtonOptionsCell.Data {
                    cell.update(data)
                }
                return cell
            }
        case .dropdown:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormDropdownCell.reuseIdentifier(), for: indexPath as IndexPath) as? FormDropdownCell {
                cell.delegate = self
                if let data = cellTemplate.data as? FormDropdownCell.Data {
                    cell.update(data)
                }
                
                return cell
            }
        case .label:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormLabelCell.reuseIdentifier(), for: indexPath) as? FormLabelCell {
                if let data = cellTemplate.data as? FormLabelCell.Data {
                    cell.update(data)
                }
                return cell
            }
        case .button:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormButtonCell.reuseIdentifier(), for: indexPath) as? FormButtonCell {
                cell.delegate = self
                if let data = cellTemplate.data as? FormButtonCell.Data {
                    cell.update(data)
                }
                return cell
            }
        case .checkboxOptions:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCheckboxOptionsCell.reuseIdentifier(), for: indexPath) as? FormCheckboxOptionsCell {
                cell.delegate = self
                if let data = cellTemplate.data as? FormCheckboxOptionsCell.Data {
                    cell.update(data)
                }
                return cell
            }
        case .password:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormPasswordCell.reuseIdentifier(), for: indexPath) as? FormPasswordCell {
                cell.delegate = self
                if let data = cellTemplate.data as? FormPasswordCell.Data {
                    cell.update(data)
                }
                return cell
            }
        case .custom:
            if let customCell = cellTemplate.customCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: customCell), for: indexPath)
                return self.delegate?.formViewController(self, updateCustomCell: cell, forCellId: cellTemplate.id) ?? UICollectionViewCell()
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
        
        let size = calculateDynamicCellHeight(cellTemplate: cell, collectionView: collectionView, indexPath: indexPath)
        return CGSize(width: floor(width), height: size.height)
    }

    private func calculateDynamicCellHeight(cellTemplate: FormViewController.Cell, collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        let sizingCell = getConfiguredCell(cellTemplate: cellTemplate, collectionView: collectionView, indexPath: indexPath)
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        let size = sizingCell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
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
        let cell = getConfiguredCell(cellTemplate: cellTemplate, collectionView: collectionView, indexPath: indexPath)
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
