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
    
    init(actualDelegate: TableModule, section: Int) {
        self.actualDelegate = actualDelegate
        self.section = section
        preparations = self.actualDelegate.preparations
    }
    
    func rowsCount() -> Int {
        return actualDelegate.tableView(collection!, numberOfRowsInSection: 0)
    }
        
    func reload() {
        collection?.reloadSections(IndexSet(integer: section), with: .none)
    }
}

protocol TableModule: NSObjectProtocol, UITableViewDelegate, UITableViewDataSource {
    var reusable: TableReusable { set get }
    var preparations: (UITableView) -> Void { get }
    var reload: () -> Void { set get }
}
