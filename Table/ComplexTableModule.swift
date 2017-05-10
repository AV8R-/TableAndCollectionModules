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
}

internal final class ComplexTableModuleObject: TableModuleObject {
    typealias CollectionType = UITableView
    typealias ReusableViewType = TableReusable
    typealias Submodule = TableModuleObject
    
    var submodules: [TableModuleObject] = []
    
    required init(module: TableModule, section: Int) {
        super.init(module: module, section: section)
        if let complex = module as? ComplexTableModule {
            complex.append = append
            submodules = complex.submodules.map { Submodule(module: $0, section: section) }
            complex.submodules.removeAll()
        }
    }
    
    override var preparations: (CollectionType) -> Void {
        set {}
        get {
            return { collection in
                self.submodules.forEach { [unowned self] in
                    $0.section = self.section
                    $0.collection = self.collection
                    $0.actualDelegate.reload = self.reload
                    $0.reusable.register(for: collection)
                    $0.preparations(collection)
                }
            }
        }
    }
    
    override func reload() {
        collection?.reloadSections(IndexSet(integer: section), with: .none)
    }
    
    override func rowsCount() -> Int {
        return submodules.reduce(0) {
            $0 + $1.rowsCount()
        }
    }
    
    func append(submodule: TableModule) {
        submodules.append(Submodule(module: submodule, section: section))
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
    var append: (TableModule) -> Void = { _ in }
    
    fileprivate var submodules: [TableModule] = []
    
    override init() {
        super.init()
        append = { [unowned self] in self.submodules.append($0) }
    }
    
    // These methods should not get called
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
