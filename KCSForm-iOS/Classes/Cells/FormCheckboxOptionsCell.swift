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

public class FormCheckboxOptionsCell: FormCell {
    
    public class Data: FormCellData {
        public var title: String?
        public var options: [String]
        public var optionStates: [String: Bool]
        
        public init(title: String?, options: [String], optionStates: [String: Bool]) {
            self.title = title
            self.options = options
            self.optionStates = optionStates
        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var groupStackView: UIStackView!
    @IBOutlet var stackView: UIStackView!
    
    fileprivate var checkboxViews = [CheckboxView]()
    var delegate: FormCheckboxOptionsCellDelegate?
    
    public var options: [String]?

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.textColor = FormStyle.shared.fieldTitleColor
        self.titleLabel.font = FormStyle.shared.fieldTitleFont
        self.stackView.spacing = FormStyle.shared.checkboxItemSpacing
        //Add 5 below to the default because something about the stackview makes it lose 5 pixels, trust me.
        self.groupStackView.spacing = FormStyle.shared.fieldTitleBottomMargin+5
        
    }
    
    public func update(_ data: Data) {
     
        self.titleLabel.isHidden = (data.title == nil)
        self.titleLabel.text = data.title
        self.options = data.options
        clearStackView()
        for (index, option) in data.options.enumerated() {
            let checkboxView = createCheckboxView(index, title: option, selected: data.optionStates[option] ?? false)
            checkboxViews.append(checkboxView)
            stackView.addArrangedSubview(checkboxView)
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
