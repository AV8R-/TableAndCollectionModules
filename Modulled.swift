//
//  Modulled.swift
//  UltimateGuitar
//
//  Created by admin on 3/28/17.
//
//

import UIKit

protocol ModuleObject {
    associatedtype CollectionType
    associatedtype ReusableViewType
    
    var reusable: ReusableViewType { set get }
    var preparations: (CollectionType) -> Void { get }
    var collection: CollectionType? { set get }
    func numberOfSection(in collection: CollectionType) -> Int
    func collection(_ collection: CollectionType, rowsIn section: Int) -> Int
}

class CollectionModuleObject: ModuleObject {
    internal var collection: UICollectionView?

    typealias CollectionType = UICollectionView
    typealias ReusableViewType = CollectionReusable
    
    var actualDelegate: CollectionModule
    init(actualDelegate: CollectionModule) {
        self.actualDelegate = actualDelegate
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
}

protocol CollectionModule: NSObjectProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var reusable: CollectionReusable { set get }
    var preparations: (UICollectionView) -> Void { get }
}

class TableModuleObject: ModuleObject {
    typealias CollectionType = UITableView
    typealias ReusableViewType = TableReusable
    
    internal var collection: UITableView?
    internal var reusable: TableReusable {
        set {
            actualDelegate.reusable = reusable
        }
        get {
            return actualDelegate.reusable
        }
    }
    
    var preparations: (UITableView) -> Void = { _ in }
    
    var actualDelegate: TableModule
    
    init(actualDelegate: TableModule) {
        self.actualDelegate = actualDelegate
        preparations = self.actualDelegate.preparations
    }
    
    internal func numberOfSection(in collection: UITableView) -> Int {
        return actualDelegate.numberOfSections?(in: collection) ?? 1
    }
    
    internal func collection(_ collection: UITableView, rowsIn section: Int) -> Int {
        return actualDelegate.tableView(collection, numberOfRowsInSection: section)
    }
    
}

protocol TableModule: NSObjectProtocol, UITableViewDelegate, UITableViewDataSource {
    var reusable: TableReusable { set get }
    var preparations: (UITableView) -> Void { get }
}

class Modulled<ModuleType: ModuleObject>: NSObject where ModuleType.ReusableViewType: Reusable, ModuleType.ReusableViewType.CollectionType == ModuleType.CollectionType {
    var collection: ModuleType.CollectionType
    var modules: [ModuleType] = []

    func module(at section: Int) -> ModuleType {
        return modules[section]
    }
    
    func prepare() {
        for var module in modules {
            module.collection = collection
            module.reusable.register(for: collection)
            module.preparations(collection)
        }
    }
    
    init(collection: ModuleType.CollectionType) {
        self.collection = collection
        super.init()
    }
}
