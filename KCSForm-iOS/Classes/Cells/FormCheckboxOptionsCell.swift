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
        public var options: [String]
        public var optionStates: [String: Bool]
        
        public init(options: [String], optionStates: [String: Bool]) {
            self.options = options
            self.optionStates = optionStates
        }
    }
    
    @IBOutlet var stackView: UIStackView!
    
    fileprivate var checkboxViews = [CheckboxView]()
    var delegate: FormCheckboxOptionsCellDelegate?
    
    public var options: [String]?

    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.stackView.spacing = FormStyle.shared.checkboxItemSpacing
        
    }
    
    public func update(_ data: Data) {
     
        self.options = data.options
        clearStackView()
        for (index, option) in data.options.enumerated() {
            let checkboxView = createCheckboxView(index, title: option, selected: data.optionStates[option] ?? false)
            checkboxViews.append(checkboxView)
            stackView.addArrangedSubview(checkboxView)
            //checkboxView.heightAnchor.constraint(equalToConstant: 65).isActive = true
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
