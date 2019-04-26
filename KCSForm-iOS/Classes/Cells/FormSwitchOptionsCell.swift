//
//  FormSwitchOptions.swift
//  KCSForm-iOS
//
//  Created by sean batson on 2019-04-03.
//

import UIKit

protocol FormSwitchOptionsCellDelegate {
    func formSwitchOptionsCell(_ cell: FormSwitchOptionsCell, isOn: Bool, forIndex: Int)
}

public class FormSwitchOptionsCell: UICollectionViewCell, FormCell {
    
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
    
    fileprivate var switchOptionViews = [SwitchOptions]()
    var delegate: FormSwitchOptionsCellDelegate?

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.textColor = FormStyle.shared.fieldTitleColor
        self.titleLabel.font = FormStyle.shared.fieldTitleFont
        self.titleBottomConstraint.constant = FormStyle.shared.fieldTitleBottomMargin
        self.stackView.spacing = FormStyle.shared.switchOptionItemSpacing
        
    }
    
    public func update(_ data: Data) {
     
        titleLabel.text = data.title
        clearStackView()
        for (index, option) in data.options.enumerated() {
            let switchOptionView = createSwitchOptionView(index, title: option, selected: data.optionStates[option] ?? false)
            switchOptionViews.append(switchOptionView)
            stackView.addArrangedSubview(switchOptionView)
        }
        
    }
    
    private func createSwitchOptionView(_ index: Int, title: String, selected: Bool) -> SwitchOptions {
        if let view = Bundle(for: FormViewController.self).loadNibNamed("SwitchOptions", owner: self, options: nil)?.first as? SwitchOptions {
            view.delegate = self
            view.title.text = title
            view.title.font = FormStyle.shared.checkboxFont
            view.setOn(selected)
            view.tag = index
            
            return view
        }
        return SwitchOptions()
    }
    
    private func clearStackView() {
        for switchOptionView in switchOptionViews {
            stackView.removeArrangedSubview(switchOptionView)
            switchOptionView.removeFromSuperview()
        }
        switchOptionViews.removeAll()
    }

}

extension FormSwitchOptionsCell: SwitchOptionDelegate {
    func switchOptionView(_ view: SwitchOptions, isOn: Bool) {
        delegate?.formSwitchOptionsCell(self, isOn: isOn, forIndex: view.tag)
    }
}
