//
//  DyanmicHeightCollectionView.swift
//  DropDown
//
//  Created by Matthew Patience on 2020-02-18.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
    }

}
