//
//  ColorOptionCell.swift
//  KCSForm-iOS
//
//  Created by Matthew Patience on 2020-02-19.
//

import UIKit

class ColorOptionCell: FormCell {
    
    @IBOutlet var colorView: UIView!
    @IBOutlet var selectionMaskView: UIView!
    
    private lazy var disabledLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.style.colorOptionSize, y: self.style.colorOptionSize))
        path.move(to: CGPoint(x: self.style.colorOptionSize, y: 0))
        path.addLine(to: CGPoint(x: 0, y: self.style.colorOptionSize))
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 1
        return layer
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.colorView.layer.borderColor = UIColor.black.cgColor
        self.selectionMaskView.isHidden = true
        self.selectionMaskView.layer.borderColor = UIColor.white.cgColor
        self.selectionMaskView.layer.borderWidth = 3
    }
    
    internal override func updateStyle() {
        self.colorView.layer.cornerRadius = self.style.colorOptionCornerRadius
        self.selectionMaskView.layer.cornerRadius = self.style.colorOptionCornerRadius
    }
    
    public func setColor(_ color: UIColor) {
        self.colorView.backgroundColor = color
    }
    
    public func setSelected(_ selected: Bool) {
        self.selectionMaskView.isHidden = !selected
        self.colorView.layer.borderWidth = selected ? 1 : 0
    }
    
    public func setDisabled(_ disabled: Bool) {
        if disabled {
            self.colorView.alpha = 0.4
            self.colorView.layer.addSublayer(self.disabledLayer)
        } else {
            self.colorView.alpha = 1.0
            self.disabledLayer.removeFromSuperlayer()
        }
    }

}
