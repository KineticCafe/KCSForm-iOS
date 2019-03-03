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

public class FormButtonOptionsCell: UICollectionViewCell, FormCell {
    
    public class Data: FormCellData {
        let title: String?
        let selectedOptions: [Int]?
        let multiSelect: Bool
        let options: [String]
        
        public init(title: String? = nil, multiSelect: Bool, selectedOptionIndex: [Int]? = nil, options: [String]) {
            self.title = title
            self.multiSelect = multiSelect
            self.selectedOptions = selectedOptionIndex
            self.options = options
        }
    }

    //IBOutlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var stackViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Constants
    
    /* The space between option buttons */
    public static var buttonHorizontalSpacing: CGFloat                     = 10
    
    /* The option button height */
    public static var buttonHeightConstraint: CGFloat                      = 44
    
    
    //MARK: - Properties
    var delegate: FormButtonOptionsCellDelegate?
    private var buttons = [UIButton]()
    private var options: [String]?
    private var selectedOptions = [Int]()
    private var multiSelect = false
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.textColor = FormStyle.shared.fieldTitleColor
        self.titleLabel.font = FormStyle.shared.fieldTitleFont
        self.titleBottomConstraint.constant = FormStyle.shared.fieldTitleBottomMargin
    }
    
    public func update(_ data: Data) {
        
        stackViewHeightConstraint.constant = FormButtonOptionsCell.buttonHeightConstraint
        stackView.spacing = FormButtonOptionsCell.buttonHorizontalSpacing
        
        var title = data.title
        if title == nil || title?.count == 0 {
            title = " "
        }
        titleLabel.text = title
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
        button.titleLabel?.font = FormStyle.shared.fieldEntryFont
        button.tag = index
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.titleLabel?.font = FormStyle.shared.buttonLabelFont
        button.layer.cornerRadius = FormStyle.shared.fieldCornerRadius
        button.layer.borderWidth = FormStyle.shared.fieldBorderWidth
        button.layer.borderColor = FormStyle.shared.fieldBorderColor.cgColor
        if selected {
            button.backgroundColor = FormStyle.shared.fieldBorderColor
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .white
            button.setTitleColor(FormStyle.shared.buttonLabelColor, for: .normal)
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
