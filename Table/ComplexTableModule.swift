//
//  ComplexTableModule.swift
//  Jobok
//
//  Created by Bogdan Manshilin on 10.05.17.
//  Copyright © 2017 Jobok. All rights reserved.
//

import UIKit

enum ModulesError: Error {
    case unableRetrieveSubmodule
    case emptyCollection
}

internal final class ComplexTableModuleObject: TableModuleObject {
    typealias CollectionType = UITableView
    typealias ReusableViewType = TableReusable
    typealias Submodule = TableModuleObject
    
    var submodules: [TableModuleObject] = []
    
    required init(module: TableModule, section: Int) {
        super.init(module: module, section: section)
        if let complex = module as? ComplexTableModule {
            complex.append = { [unowned self] in try self.append(submodule: $0) }
            complex.count = { [unowned self] in self.submodules.count }
            submodules = complex.submodules.map { Submodule(module: $0, section: section) }
            complex.submodules.removeAll()
        }
    }
    
    override var preparations: (CollectionType) -> Void {
        set {}
        get {
            return { collection in
                do {
                    try self.submodules.forEach { [unowned self] in
                        try self.setup(submodule: $0)
                    }
                } catch {
                    print("Error setting up submodule object in complex module")
                }
            }
        }
    }
    
    override func reload() {
        UIView.setAnimationsEnabled(false)
        collection?.reloadSections(IndexSet(integer: section), with: .none)
        UIView.setAnimationsEnabled(true)
    }
    
    override func rowsCount() -> Int {
        return submodules.reduce(0) {
            $0 + $1.rowsCount()
        }
    }
    
    func append(submodule: TableModule) throws {
        let submodule = Submodule(module: submodule, section: section)
        try setup(submodule: submodule)
        submodules.append(submodule)
    }
    
    func setup(submodule: Submodule) throws {
        guard let collection = collection else {
            throw ModulesError.emptyCollection
        }
        
        submodule.collection = collection
        submodule.actualDelegate.reload = reload
        submodule.reusable.register(for: collection)
        submodule.preparations(collection)
    }
    
    override func didSelect(row: Int) {
        do {
            try module(at: row).didSelect(row: row)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func height(for row: Int) -> CGFloat {
        do {
            return try module(at: row).height(for: row)
        } catch {
            print(error.localizedDescription)
        }
        return super.height(for: row)
    }
    
    override func cell(for row: Int) -> UITableViewCell {
        do {
            return try module(at: row).cell(for: row)
        } catch {
            print(error.localizedDescription)
        }
        return super.cell(for: row)
    }
    
    override func willSelect(path: IndexPath) -> IndexPath? {
        do {
            return try module(at: path.row).willSelect(path: path)
        } catch {
            print(error.localizedDescription)
        }
        return super.willSelect(path: path)

    }
    
    override func willDisplay(cell: UITableViewCell, at indexPath: IndexPath) {
        do {
            return try module(at: indexPath.row).willDisplay(cell: cell, at: indexPath)
        } catch {
            print(error.localizedDescription)
        }
        return super.willDisplay(cell: cell, at: indexPath)

    }
    
    func module(at row: Int) throws -> Submodule {
        var rows = 0
        for submodule in submodules {
            rows += submodule.rowsCount()
            if row < rows {
                return submodule
            }
        }
        throw ModulesError.unableRetrieveSubmodule
    }
}

public final class ComplexTableModule: NSObject, TableModule {

    var reusable: TableReusable = .class(UITableViewCell.self)
    var preparations: (UITableView) -> Void = {_ in}
    var reload: () -> Void = {}
    var append: (TableModule) throws -> Void = { _ in }
    var count: () -> Int = { 0 }
    
    fileprivate var submodules: [TableModule] = []
    
    override init() {
        super.init()
        append = { [unowned self] in self.submodules.append($0) }
        count = { [unowned self] in self.submodules.count }
    }
    
    convenience init(submodules: [TableModule]) {
        self.init()
        self.submodules = submodules
    }
    
    // These methods should not get called
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
