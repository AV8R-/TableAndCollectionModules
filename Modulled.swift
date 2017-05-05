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
    }
    
    var reusable: ReusableViewType {
        set {
            actualDelegate.reusable = reusable
        }
        get {
            return actualDelegate.reusable
        }
    }
    
    func numberOfSection(in collection: CollectionType) -> Int {
        return actualDelegate.numberOfSections?(in: collection) ?? 1
    }
    func collection(_ collection: CollectionType, rowsIn section: Int) -> Int {
        return actualDelegate.collectionView(collection, numberOfItemsInSection: section)
    }
}

protocol CollectionModule: NSObjectProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var reusable: CollectionReusable { set get }
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
    var actualDelegate: TableModule
    
    init(actualDelegate: TableModule) {
        self.actualDelegate = actualDelegate
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
}

class Modulled<ModuleType: ModuleObject>: NSObject where ModuleType.ReusableViewType: Reusable, ModuleType.ReusableViewType.CollectionType == ModuleType.CollectionType {
    var collection: ModuleType.CollectionType
    var didChangeContentHandler: (() -> Void)?
    var modules: [ModuleType] = []
    var tableMapping: [Int: Int] = [:]
    var moduleMapping: [Int: (index:Int, sectionOffset:Int)] = [:]
    var totalNumberOfSections: Int = 0

    func module(at path: IndexPath) -> (module: ModuleType, modulePath: IndexPath) {
        let data = moduleMapping[path.section]!
        let module = modules[data.index]
        let path = IndexPath(row: path.row, section: path.section - data.sectionOffset)
        return (module, path)
    }
    
    func prepare() {
        var totalSections = 0
        for (index, var module) in modules.enumerated() {
            module.collection = collection
            module.reusable.register(for: collection)
            let sections = module.numberOfSection(in: collection)
            for section in 0..<sections {
                let rows = module.collection(collection, rowsIn: section)
                tableMapping[totalSections + section] = rows
                moduleMapping[totalSections + section] = (index, section + totalSections)
            }
            totalSections += sections
        }
        totalNumberOfSections = totalSections
    }
    
    init(collection: ModuleType.CollectionType) {
        self.collection = collection
        super.init()
    }
}
