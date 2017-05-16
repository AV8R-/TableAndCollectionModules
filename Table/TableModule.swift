//
//  TableModule.swift
//  Jobok
//
//  Created by Bogdan Manshilin on 10.05.17.
//  Copyright © 2017 Jobok. All rights reserved.
//

import UIKit

class TableModuleObject: ModuleObject {
    typealias CollectionType = UITableView
    typealias ReusableViewType = TableReusable
    typealias ActualModule = TableModule
    
    internal var collection: UITableView?
    var section: Int
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
    
    required init(module: TableModule, section: Int) {
        self.actualDelegate = module
        self.section = section
        self.actualDelegate.reload = reload
        preparations = self.actualDelegate.preparations
    }
    
    func rowsCount() -> Int {
        return actualDelegate.tableView(collection!, numberOfRowsInSection: 0)
    }
    
    func reload() {
        UIView.setAnimationsEnabled(false)
        collection?.reloadSections(IndexSet(integer: section), with: .none)
        UIView.setAnimationsEnabled(true)
    }
    
    func cell(for row: Int) -> UITableViewCell {
        return actualDelegate.tableView(collection!, cellForRowAt: IndexPath(row: row, section: 0))
    }
    
    func height(for row: Int) -> CGFloat {
        return actualDelegate.tableView?(collection!, heightForRowAt: IndexPath(row: row, section: 0)) ?? 0
    }
    
    func didSelect(row: Int) {
        actualDelegate.tableView?(collection!, didSelectRowAt: IndexPath(row: row, section: 0))
    }
    
    func willSelect(path: IndexPath) -> IndexPath? {
        if actualDelegate.responds(to: #selector(UITableViewDelegate.tableView(_:willSelectRowAt:))) {
            return actualDelegate.tableView?(collection!, willSelectRowAt: path)
        } else {
            return path
        }
    }
    
    func willDisplay(cell: UITableViewCell, at indexPath: IndexPath) {
        actualDelegate.tableView?(collection!, willDisplay: cell, forRowAt: indexPath)
    }
}

protocol TableModule: NSObjectProtocol, UITableViewDelegate, UITableViewDataSource {
    var reusable: TableReusable { set get }
    var preparations: (UITableView) -> Void { get }
    var reload: () -> Void { set get }
}
