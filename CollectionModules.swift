//
//  Modules.swift
//  Jobok
//
//  Created by Bogdan Manshilin on 10.05.17.
//  Copyright © 2017 Jobok. All rights reserved.
//

import UIKit

class CollectionModuleObject: ModuleObject {
    internal var collection: UICollectionView?
    var section: Int
    
    typealias CollectionType = UICollectionView
    typealias ReusableViewType = CollectionReusable
    
    var actualDelegate: CollectionModule
    init(actualDelegate: CollectionModule, section: Int) {
        self.actualDelegate = actualDelegate
        self.section = section
        preparations = self.actualDelegate.preparations
    }
    
    var reusable: ReusableViewType {
        set {
            actualDelegate.reusable = reusable
        }
        get {
            return actualDelegate.reusable
        }
    }
    
    var preparations: (UICollectionView) -> Void = { _ in }
    
    func numberOfSection(in collection: CollectionType) -> Int {
        return actualDelegate.numberOfSections?(in: collection) ?? 1
    }
    func collection(_ collection: CollectionType, rowsIn section: Int) -> Int {
        return actualDelegate.collectionView(collection, numberOfItemsInSection: section)
    }
    
    func reload() {
        collection?.reloadSections(IndexSet(integer: section))
    }
}

protocol CollectionModule: NSObjectProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var reusable: CollectionReusable { set get }
    var preparations: (UICollectionView) -> Void { get }
    var reload: () -> Void { set get }
}
