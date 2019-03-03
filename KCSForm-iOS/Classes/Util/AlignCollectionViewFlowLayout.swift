//
//  AlignCollectionViewFlowLayout.swift
//  KCSForm-iOS
//
//  Created by Matthew Patience on 2019-03-01.
//

import UIKit

class AlignCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    class AlignWithTopFlowLayoutRowInfo: NSObject {
        var centerY: CGFloat = 0
        var top: CGFloat = 0
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesCopy: [UICollectionViewLayoutAttributes] = []
        if let attributes = super.layoutAttributesForElements(in: rect) {
            attributes.forEach({ attributesCopy.append($0.copy() as! UICollectionViewLayoutAttributes) })
        }
        
        for attributes in attributesCopy {
            if attributes.representedElementKind == nil {
                let indexpath = attributes.indexPath
                if let attr = layoutAttributesForItem(at: indexpath) {
                    attributes.frame = attr.frame
                }
            }
        }
        
        var rowInfos = [AlignWithTopFlowLayoutRowInfo]()
        
        for attributes in attributesCopy {
            var found = false
            for info in rowInfos {
                if (fabs(info.centerY - attributes.center.y) < 1) {
                    found = true
                    if (info.top > attributes.frame.origin.y) {
                        info.centerY = attributes.center.y
                        info.top = attributes.frame.origin.y
                    }
                    break;
                }
            }
            if !found {
                let rowInfo = AlignWithTopFlowLayoutRowInfo()
                rowInfo.centerY = attributes.center.y
                rowInfo.top = attributes.frame.origin.y
                rowInfos.append(rowInfo)
            }
        }
    
        for attributes in attributesCopy {
            for info in rowInfos {
                if (fabs(info.centerY - attributes.center.y) < 1) {
                    var r = attributes.frame
                    r.origin.y = info.top
                    attributes.frame = r
                    attributes.center = CGPoint(x: r.midX, y: r.midY)
                }
            }
        }
        
        return attributesCopy;
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let currentItemAttributes = super.layoutAttributesForItem(at: indexPath as IndexPath)?.copy() as? UICollectionViewLayoutAttributes {
            let sectionInset = self.evaluatedSectionInsetForItem(at: indexPath.section)
            let isFirstItemInSection = indexPath.item == 0
            let layoutWidth = self.collectionView!.frame.width - sectionInset.left - sectionInset.right
            
            if (isFirstItemInSection) {
                currentItemAttributes.leftAlignFrameWithSectionInset(sectionInset)
                return currentItemAttributes
            }
            
            let previousIndexPath = IndexPath.init(row: indexPath.item - 1, section: indexPath.section)
            
            let previousFrame = layoutAttributesForItem(at: previousIndexPath)?.frame ?? CGRect.zero
            let previousFrameRightPoint = previousFrame.origin.x + previousFrame.width
            let currentFrame = currentItemAttributes.frame
            let strecthedCurrentFrame = CGRect.init(x: sectionInset.left,
                                                    y: currentFrame.origin.y,
                                                    width: layoutWidth,
                                                    height: currentFrame.size.height)
            // if the current frame, once left aligned to the left and stretched to the full collection view
            // widht intersects the previous frame then they are on the same line
            let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
            
            if (isFirstItemInRow) {
                // make sure the first item on a line is left aligned
                currentItemAttributes.leftAlignFrameWithSectionInset(sectionInset)
                return currentItemAttributes
            }
            
            var frame = currentItemAttributes.frame
            frame.origin.x = previousFrameRightPoint + evaluatedMinimumInteritemSpacing(at: indexPath.section)
            currentItemAttributes.frame = frame
            return currentItemAttributes
            
        }
        return nil
    }
    
    func evaluatedMinimumInteritemSpacing(at sectionIndex:Int) -> CGFloat {
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            let inteitemSpacing = delegate.collectionView?(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: sectionIndex)
            if let inteitemSpacing = inteitemSpacing {
                return inteitemSpacing
            }
        }
        return self.minimumInteritemSpacing
        
    }
    
    func evaluatedSectionInsetForItem(at index: Int) ->UIEdgeInsets {
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout {
            let insetForSection = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: index)
            if let insetForSectionAt = insetForSection {
                return insetForSectionAt
            }
        }
        return self.sectionInset
    }
}

extension UICollectionViewLayoutAttributes {
    func leftAlignFrameWithSectionInset(_ sectionInset:UIEdgeInsets){
        var frame = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
}
