//
//  FormCheckboxOptionsCell.swift
//  Kiehls
//
//  Created by Matthew Patience on 2018-08-03.
//  Copyright © 2018 Kinetic Cafe. All rights reserved.
//

import UIKit

protocol FormCheckboxOptionsCellDelegate {
    func formCheckboxOptionsCell(_ cell: FormCheckboxOptionsCell, checked: Bool, forIndex: Int)
}

public class FormCheckboxOptionsCell: UICollectionViewCell, FormCell {
    
    public class Data: FormCellData {
        let title: String?
        let options: [String]
        let optionStates: [String: Bool]
        
        public init(title: String? = nil, options: [String], optionStates: [String: Bool]) {
            self.title = title
            self.options = options
            self.optionStates = optionStates
        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet weak var stackviewBottomConstraint: NSLayoutConstraint!
    
    fileprivate var checkboxViews = [CheckboxView]()
    var delegate: FormCheckboxOptionsCellDelegate?

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.textColor = FormStyle.shared.fieldTitleColor
        self.titleLabel.font = FormStyle.shared.fieldTitleFont
        self.titleBottomConstraint.constant = FormStyle.shared.fieldTitleBottomMargin
        self.stackviewBottomConstraint.constant = FormStyle.shared.checkboxBottomMargin
        self.stackView.spacing = FormStyle.shared.checkboxItemSpacing
        
    }
    
    public func update(_ data: Data) {
     
        titleLabel.text = data.title
        clearStackView()
        for (index, option) in data.options.enumerated() {
            let checkboxView = createCheckboxView(index, title: option, selected: data.optionStates[option] ?? false)
            checkboxViews.append(checkboxView)
            stackView.addArrangedSubview(checkboxView)
            stackView.setCustomSpacing(UIStackView.spacingUseSystem, after: checkboxView)
        }
        
    }
    
    private func createCheckboxView(_ index: Int, title: String, selected: Bool) -> CheckboxView {
        
        let view = CheckboxView(frame: CGRect(x: 0, y: 0, width: stackView.frame.size.width, height: 35))
        view.delegate = self
        view.titleLabel.text = title
        view.titleLabel.font = FormStyle.shared.checkboxFont
        view.setChecked(selected)
        view.tag = index
        
        return view
    }
    
    private func clearStackView() {
        for checkboxView in checkboxViews {
            stackView.removeArrangedSubview(checkboxView)
            checkboxView.removeFromSuperview()
        }
        checkboxViews.removeAll()
    }

}

extension FormCheckboxOptionsCell: CheckboxViewDelegate {
    
    func checkboxView(_ view: CheckboxView, checked: Bool) {
        delegate?.formCheckboxOptionsCell(self, checked: checked, forIndex: view.tag)
    }
    
}
