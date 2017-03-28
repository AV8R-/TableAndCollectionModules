//
//  ModulledCollectionView.swift
//  UltimateGuitar
//
//  Created by admin on 3/21/17.
//
//

import UIKit

class ModulledCollection: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    let modulled: Modulled<CollectionModuleObject>
    
    var collection: UICollectionView
    var didChangeContentHandler: (() -> Void)?
    var tableMaping: [Int: Int] = [:]
    var moduleMaping: [Int: (index:Int, sectionOffset:Int)] = [:]
    var totalNumberOfSections: Int = 0
    
    init(collectionView: UICollectionView) {
        collection = collectionView
        modulled = Modulled<CollectionModuleObject>(collection: collection)
        super.init()
        collection.delegate = self
        collection.dataSource = self
    }
    
    func prepare() {
        modulled.prepare()
    }
    
    func append(module: CollectionModule) {
        modulled.modules.append(CollectionModuleObject(actualDelegate: module))
    }
    
    //MARK: Delegate
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, shouldHighlightItemAt: indexPath) ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, didHighlightItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, didHighlightItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, shouldSelectItemAt: indexPath) ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, shouldDeselectItemAt: indexPath) ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, didDeselectItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, willDisplaySupplementaryView: view, forElementKind: elementKind, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, didEndDisplayingSupplementaryView: view, forElementOfKind: elementKind, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, shouldDeselectItemAt: indexPath) ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, canPerformAction: action, forItemAt: indexPath, withSender: sender) ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, performAction: action, forItemAt: indexPath, withSender: sender)
    }
    
    //MARK: DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return modulled.totalNumberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modulled.tableMapping[section]!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return modulled.module(at: indexPath).module.actualDelegate.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return modulled.module(at: indexPath).module.actualDelegate.collectionView!(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, canMoveItemAt: indexPath) ?? false
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        modulled.module(at: sourceIndexPath).module.actualDelegate.collectionView?(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }
}

extension ModulledCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return modulled.module(at: indexPath).module.actualDelegate.collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return modulled.module(at: IndexPath(item: 0, section: section)).module.actualDelegate.collectionView?(collectionView, layout: collectionViewLayout, insetForSectionAt: section) ?? UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return modulled.module(at: IndexPath(item: 0, section: section)).module.actualDelegate.collectionView?(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return modulled.module(at: IndexPath(item: 0, section: section)).module.actualDelegate.collectionView?(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return modulled.module(at: IndexPath(item: 0, section: section)).module.actualDelegate.collectionView?(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return modulled.module(at: IndexPath(item: 0, section: section)).module.actualDelegate.collectionView?(collectionView, layout: collectionViewLayout, referenceSizeForFooterInSection: section) ?? .zero
    }
}
