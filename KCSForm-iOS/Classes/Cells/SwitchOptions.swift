//
//  SwitchOptions.swift
//  KCSForm-iOS
//
//  Created by sean batson on 2019-04-03.
//

import UIKit

protocol SwitchOptionDelegate {
    func switchOptionView(_ view: SwitchOptions, isOn: Bool)
}

class SwitchOptions: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UISwitch!

    private var isOn: Bool = true
    public var delegate: SwitchOptionDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.title?.font = FormStyle.shared.fieldEntryFont

        updateOnState()
        
    }
    
    public func setOn(_ isOn: Bool) {
        
        self.isOn = isOn
        updateOnState()
        
    }
    
    private func updateOnState() {
        
        value.isOn = isOn
    }
    
    @IBAction func OnStateChanged(_ sender: Any?) {
        self.isOn = !isOn
        updateOnState()
        delegate?.switchOptionView(self, isOn: self.isOn)
        
    }

}
