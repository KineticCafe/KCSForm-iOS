//
//  FormColorOptionsCell.swift
//  DropDown
//
//  Created by Matthew Patience on 2020-02-19.
//

import UIKit

protocol FormColorOptionsCellDelegate {
    /** Called when a color option is selected. */
    func formColorOptionsCell(_ cell: FormColorOptionsCell, selectedOptionIndex: Int)
}

public class FormColorOptionsCell: FormCell {
    
    public class Data: FormCellData {
        public var title: String?
        public var selectedOptions: [Int]?
        public var multiSelect: Bool
        public var options: [FormColor]
        
        public init(title: String? = nil, multiSelect: Bool, selectedOptionIndex: [Int]? = nil, options: [FormColor]) {
            self.title = title
            self.multiSelect = multiSelect
            self.selectedOptions = selectedOptionIndex
            self.options = options
        }
    }
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var titlesStackView: UIStackView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var selectionLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    internal var delegate: FormColorOptionsCellDelegate?
    private var options: [FormColor]?
    public var selectedOptions = [Int]()
    private var multiSelect = false

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.textColor = FormStyle.shared.fieldTitleColor
        self.titleLabel.font = FormStyle.shared.fieldTitleFont
        self.selectionLabel.textColor = FormStyle.shared.selectedColorOptionLabelColor
        self.selectionLabel.font = FormStyle.shared.selectedColorOptionFont
        self.stackView.spacing = FormStyle.shared.fieldTitleBottomMargin
        
        self.collectionView.register(UINib.init(nibName: ColorOptionCell.reuseIdentifier, bundle: Bundle.init(for: ColorOptionCell.self)), forCellWithReuseIdentifier: ColorOptionCell.reuseIdentifier)
        let layout = AlignCollectionViewFlowLayout()
        self.collectionView.collectionViewLayout = layout
        
    }
    
    public func update(_ data: Data) {
        self.titlesStackView.isHidden = (data.title == nil)
        self.titleLabel.text = data.title
        self.multiSelect = data.multiSelect
        self.selectionLabel.isHidden = self.multiSelect
        self.options = data.options
        self.selectedOptions = data.selectedOptions ?? []
        if !self.multiSelect, self.selectedOptions.count > 0 {
            self.selectionLabel.text = self.options?[self.selectedOptions[0]].name
        } else {
            self.selectionLabel.text = ""
        }
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    }

}

extension FormColorOptionsCell: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let options = self.options {
            return options.count
        }
        
        return 0
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let options = self.options, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorOptionCell.reuseIdentifier, for: indexPath) as? ColorOptionCell else {
            return UICollectionViewCell()
        }
        let option = options[indexPath.row]
        cell.setColor(option.color ?? UIColor.black)
        cell.setSelected(selectedOptions.contains(indexPath.row))
        cell.setDisabled(!option.available)
        return cell
    }
}

extension FormColorOptionsCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FormStyle.shared.colorOptionSize, height: FormStyle.shared.colorOptionSize)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return FormStyle.shared.colorOptionSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return FormStyle.shared.colorOptionSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if multiSelect {
            if selectedOptions.contains(indexPath.row) {
                selectedOptions.removeAll { (element) -> Bool in
                    element == indexPath.row
                }
            } else {
                selectedOptions.append(indexPath.row)
            }
        } else {
            selectedOptions = [indexPath.row]
        }
        self.selectionLabel.text = self.options?[indexPath.row].name
        self.delegate?.formColorOptionsCell(self, selectedOptionIndex: indexPath.row)
        collectionView.reloadData()
    }
    
}
