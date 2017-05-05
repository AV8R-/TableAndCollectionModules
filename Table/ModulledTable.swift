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
        return modulled.tableMapping[section]!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return modulled.totalNumberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moduleData = modulled.module(at: indexPath)
        return moduleData.module.actualDelegate.tableView(tableView, cellForRowAt: moduleData.modulePath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let moduleData = modulled.module(at: indexPath)
        return moduleData.module.actualDelegate.tableView?(tableView, heightForRowAt: moduleData.modulePath) ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moduleData = modulled.module(at: indexPath)
        moduleData.module.actualDelegate.tableView?(tableView, didSelectRowAt: moduleData.modulePath)
    }
    
}
