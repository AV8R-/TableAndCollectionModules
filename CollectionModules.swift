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
    typealias ActualModule = CollectionModule
    
    var actualDelegate: CollectionModule
    required init(module: CollectionModule, section: Int) {
        self.actualDelegate = module
        self.section = section
        self.actualDelegate.reload = reload
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
    
    func rowsCount() -> Int {
        return actualDelegate.collectionView(collection!, numberOfItemsInSection: 0)
    }
    
    func reload() {
        collection?.reloadSections(IndexSet(integer: section))
    }

    func didSelect(row: Int) {
        actualDelegate.collectionView!(collection!, didSelectItemAt: IndexPath(item: row, section: 0))
    }
}

protocol CollectionModule: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var reusable: CollectionReusable { set get }
    var preparations: (UICollectionView) -> Void { get }
    var reload: () -> Void { set get }
}
