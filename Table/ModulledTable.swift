//
//  ModulledTable.swift
//  UltimateGuitar
//
//  Created by admin on 3/28/17.
//
//

import UIKit

class ModulledTable: NSObject, UITableViewDelegate, UITableViewDataSource {
    let modulled: Modulled<TableModuleObject>
    
    var collection: UITableView
    var didChangeContentHandler: (() -> Void)?
    
    init(tableView: UITableView) {
        self.collection = tableView
        modulled = Modulled<TableModuleObject>(collection: tableView)
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func append(module: TableModule) {
        modulled.modules.append(TableModuleObject(actualDelegate: module))
    }
    
    func preapre() {
        modulled.prepare()
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return modulled.module(at: section).actualDelegate.tableView(collection, numberOfRowsInSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return modulled.modules.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let module = modulled.module(at: indexPath.section)
        return module.actualDelegate.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let module = modulled.module(at: indexPath.section)
        return module.actualDelegate.tableView?(tableView, heightForRowAt: indexPath) ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let module = modulled.module(at: indexPath.section)
        module.actualDelegate.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
}
