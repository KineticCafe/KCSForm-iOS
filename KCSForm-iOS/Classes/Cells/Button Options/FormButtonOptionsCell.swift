//
//  FormButtonOptionsCell.swift
//  Kiehls
//
//  Created by Steven Andrews on 2018-05-28.
//  Copyright © 2018 Kinetic Cafe. All rights reserved.
//

import UIKit

protocol FormButtonOptionsCellDelegate {
    /** Called when a button is selected. */
    func formButtonOptionsCell(_ cell: FormButtonOptionsCell, selectedOptionIndex: Int)
}

public class FormButtonOptionsCell: FormCell {
    
    public class Data: FormCellData {
        public var title: String?
        public var selectedOptions: [Int]?
        public var multiSelect: Bool
        public var options: [String]
        
        public init(title: String?, multiSelect: Bool, selectedOptionIndex: [Int]? = nil, options: [String]) {
            self.title = title
            self.multiSelect = multiSelect
            self.selectedOptions = selectedOptionIndex
            self.options = options
        }
    }

    //IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var groupStackView: UIStackView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var stackViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Constants
    
    
    //MARK: - Properties
    var delegate: FormButtonOptionsCellDelegate?
    private var buttons = [UIButton]()
    private var options: [String]?
    public var selectedOptions = [Int]()
    private var multiSelect = false
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    internal override func updateStyle() {
        self.titleLabel.textColor = self.style.fieldTitleColor
        self.titleLabel.font = self.style.fieldTitleFont
        self.groupStackView.spacing = self.style.fieldTitleBottomMargin
    }
    
    public func update(_ data: Data) {
        
        stackViewHeightConstraint.constant = self.style.buttonOptionHeight
        stackView.spacing = self.style.buttonOptionHorizontalSpacing
        
        titleLabel.isHidden = (data.title == nil)
        titleLabel.text = data.title
        self.multiSelect = data.multiSelect
        
        updateOptions(data.options, selectedOptions: data.selectedOptions ?? [])
        
    }
    
    private func updateOptions(_ options:[String], selectedOptions: [Int]) {
        self.options = options
        self.selectedOptions = selectedOptions
        clearStackView()
        for index in 0..<options.count {
            var selected = false
            for selection in selectedOptions {
                if selection == index {
                    selected = true
                    break
                }
            }
            let button = createButton(index, selected: selected)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createButton(_ index: Int, selected: Bool) -> UIButton {
        
        let button = UIButton()
        if let options = options {
            button.setTitle(options[index], for: .normal)
        }
        button.titleLabel?.font = self.style.fieldEntryFont
        button.tag = index
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.titleLabel?.font = self.style.buttonLabelFont
        button.layer.cornerRadius = self.style.fieldCornerRadius
        button.layer.borderWidth = self.style.fieldBorderWidth
        button.layer.borderColor = self.style.fieldBorderColor.cgColor
        if selected {
            button.backgroundColor = self.style.fieldBorderColor
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .clear
            button.setTitleColor(self.style.buttonLabelColor, for: .normal)
        }
        
        return button
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        var selected = true
        for selection in self.selectedOptions {
            if sender.tag == selection {
                selected = false
                break
            }
        }
        if self.multiSelect {
            if selected {
                self.selectedOptions.append(sender.tag)
            } else {
                self.selectedOptions.removeAll(where: { $0 == sender.tag })
            }
            delegate?.formButtonOptionsCell(self, selectedOptionIndex: sender.tag)
        } else {
            self.selectedOptions = [sender.tag]
            if selected {
                delegate?.formButtonOptionsCell(self, selectedOptionIndex: sender.tag)
            }
        }
        updateOptions(self.options ?? [], selectedOptions: self.selectedOptions)
    }
    
    private func clearStackView() {
        for button in buttons {
            stackView.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        buttons.removeAll()
    }

}
