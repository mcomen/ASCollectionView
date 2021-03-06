//
//  ASCollectionViewLayoutTests.swift
//  ASCollectionView
//
//  Created by Abdullah Selek on 31/07/16.
//  Copyright © 2016 Abdullah Selek. All rights reserved.
//

import Quick
import Nimble

@testable import ASCollectionView

class ASCollectionViewLayoutTests: QuickSpec {
    
    override func spec() {
        describe("CollectionView Layout") {
            context("When init success") {
                var collectionViewLayout: ASCollectionViewLayout!
                beforeEach {
                    collectionViewLayout = ASCollectionViewLayout()
                }
                
                it("just init") {
                    expect(collectionViewLayout).notTo(beNil())
                }
            }
//            context("Check content size is set") {
//                var collectionViewLayout: ASCollectionViewLayout!
//                beforeEach {
//                    collectionViewLayout = MockCollectionViewLayout()
//                }
//                it("should returns set value") {
//                    expect(collectionViewLayout.collectionViewContentSize).to(equal(CGSize(width: 200, height: 200)))
//                }
//            }
            context("Attributes for elements") {
                var collectionViewLayout: ASCollectionViewLayout!
                beforeEach {
                    collectionViewLayout = MockCollectionViewLayout()
                }
                it("should return set elements") {
                    expect(collectionViewLayout.layoutAttributesForElements(in: CGRect(x: 0, y: 0, width: 320, height: 50))).to(haveCount(2))
                }
            }
            context("Attributes for item item index path") {
                var collectionViewLayout: ASCollectionViewLayout!
                beforeEach {
                    collectionViewLayout = MockCollectionViewLayout()
                }
                it("should return a valid attribute") {
                    collectionViewLayout.layoutAttributesForElements(in: CGRect(x: 0, y: 0, width: 320, height: 50))
                    expect(collectionViewLayout.layoutAttributesForItem(at: IndexPath(row: 1, section: 0))).notTo(beNil())
                    expect(collectionViewLayout.layoutAttributesForItem(at: IndexPath(row: 1, section: 0))).notTo(equal(UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: 0, section: 0))))
                }
            }
            context("Attributes for supplementary view") {
                var collectionViewLayout: ASCollectionViewLayout!
                beforeEach {
                    collectionViewLayout = MockCollectionViewLayout()
                }
                it("should return a valid attribute") {
                    expect(collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: "Header", at: IndexPath(row: 1, section: 0))).notTo(beNil())
                }
            }
            context("Invalidate layout") {
                var collectionViewLayout: ASCollectionViewLayout!
                beforeEach {
                    collectionViewLayout = MockCollectionViewLayout()
                }
                it("should return true") {
                    expect(collectionViewLayout.shouldInvalidateLayout(forBoundsChange: CGRect(x: 0, y: 0, width: 320, height: 50))).to(equal(true))
                }
            }
        }
    }
    
    class MockCollectionViewLayout: ASCollectionViewLayout {
        let cellAttributes = NSMutableDictionary(capacity: 2)
        var headerAttributes: UICollectionViewLayoutAttributes!
        
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            var result = [UICollectionViewLayoutAttributes]()
            for itemCount in 0 ..< 2 {
                let indexPath = IndexPath(item: itemCount, section: SECTION)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                cellAttributes.setObject(attributes, forKey: indexPath as NSCopying)
            }
            for itemCount in 0 ..< 2 {
                let indexPath = IndexPath(item: itemCount, section: SECTION)
                let attributes = cellAttributes.object(forKey: indexPath) as! UICollectionViewLayoutAttributes
                
                if rect.intersects(attributes.frame) {
                    result.append(attributes)
                }
            }
            
            return result
        }
        
        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            return cellAttributes.object(forKey: indexPath) as? UICollectionViewLayoutAttributes
        }
        
        override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            headerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: ASCollectionViewElement.Header, with: IndexPath(row: 0, section: SECTION))
            headerAttributes.frame = CGRect(x: 0, y: 0, width: 320, height: self.headerSize.height);
            return headerAttributes
        }
        
        override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return true
        }
    }
    
}
