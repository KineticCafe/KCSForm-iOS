//
//  FormTagsCell.swift
//  KCSForm-iOS
//
//  Created by Matthew Patience on 2020-02-13.
//

import UIKit

protocol FormTagsCellDelegate {
    /** Called when a tag is selected. */
    func formTagsCell(_ cell: FormTagsCell, selectedOptionIndex: Int)
}

public class FormTagsCell: FormCell {
    
    public class Data: FormCellData {
        public var title: String?
        public var selectedOptions: [Int]?
        public var multiSelect: Bool
        public var dynamicSize: Bool
        public var options: [String]
        
        public init(title: String? = nil, multiSelect: Bool, dynamicSize: Bool, selectedOptionIndex: [Int]? = nil, options: [String]) {
            self.title = title
            self.multiSelect = multiSelect
            self.dynamicSize = dynamicSize
            self.selectedOptions = selectedOptionIndex
            self.options = options
        }
    }
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    internal var delegate: FormTagsCellDelegate?
    private var options: [String]?
    public var selectedOptions = [Int]()
    fileprivate var multiSelect = false
    fileprivate var dynamicSize = false
    fileprivate var largestWidth = CGFloat(0)

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.textColor = FormStyle.shared.fieldTitleColor
        self.titleLabel.font = FormStyle.shared.fieldTitleFont
        self.stackView.spacing = FormStyle.shared.fieldTitleBottomMargin
        
        self.collectionView.register(UINib.init(nibName: TagCell.reuseIdentifier, bundle: Bundle.init(for: TagCell.self)), forCellWithReuseIdentifier: TagCell.reuseIdentifier)
        let layout = AlignCollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        self.collectionView.collectionViewLayout = layout
    }
    
    public func update(_ data: Data) {
        self.titleLabel.isHidden = (data.title == nil)
        self.titleLabel.text = data.title
        self.multiSelect = data.multiSelect
        self.dynamicSize = data.dynamicSize
        self.options = data.options
        largestWidth = getWidthOfLargestOption(data.options)
        self.selectedOptions = data.selectedOptions ?? []
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
    }
    
    private func getWidthOfLargestOption(_ options: [String]) -> CGFloat {
        var largestWidth = CGFloat(0)
        for option in options {
            let width = option.size(withAttributes: [.font: FormStyle.shared.tagFont]).width
            if width > largestWidth {
                largestWidth = width
            }
        }
        return largestWidth
    }
    
    private func getCellWidth(forOption option: String) -> CGFloat {
        var width = self.largestWidth
        if self.dynamicSize {
            width = option.size(withAttributes: [.font: FormStyle.shared.tagFont]).width
        }
        return (width + 5 + FormStyle.shared.tagPadding)
    }

}

extension FormTagsCell: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let options = self.options {
            return options.count
        }
        
        return 0
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let options = self.options, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseIdentifier, for: indexPath) as? TagCell else {
            return UICollectionViewCell()
        }
        let option = options[indexPath.row]
        cell.setLabel(option)
        cell.setSelected(selectedOptions.contains(indexPath.row))
        cell.setCellWidth(getCellWidth(forOption: option))
        return cell
    }
}

extension FormTagsCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let options = self.options else {
            return CGSize(width: 0, height: 0)
        }
        let option = options[indexPath.row]
        return CGSize(width: getCellWidth(forOption: option), height: FormStyle.shared.tagHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return FormStyle.shared.tagInterItemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return FormStyle.shared.tagLineSpacing
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
        self.delegate?.formTagsCell(self, selectedOptionIndex: indexPath.row)
        collectionView.reloadData()
    }
    
}
