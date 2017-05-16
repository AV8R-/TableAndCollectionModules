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
    
    var modules: [TableModule] = []
    
    func append(module: TableModule) {
        modules.append(module)
        if let module = module as? ComplexTableModule {
            modulled.modules.append(ComplexTableModuleObject(module: module, section: modulled.modules.count))
        } else {
            modulled.modules.append(TableModuleObject(module: module, section: modulled.modules.count))
        }
    }
    
    func preapre() {
        modulled.prepare()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return modulled.modules.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modulled.module(at: section).rowsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let module = modulled.module(at: indexPath.section)
        return module.cell(for: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let module = modulled.module(at: indexPath.section)
        return module.height(for: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let module = modulled.module(at: indexPath.section)
        module.didSelect(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let module = modulled.module(at: indexPath.section)
        return module.willSelect(path: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let module = modulled.module(at: indexPath.section)
        module.willDisplay(cell: cell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let module = modulled.module(at: section)
        return module.actualDelegate.tableView?(tableView, heightForHeaderInSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let module = modulled.module(at: section)
        return module.actualDelegate.tableView?(tableView, heightForFooterInSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let module = modulled.module(at: section)
        return module.actualDelegate.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let module = modulled.module(at: section)
        return module.actualDelegate.tableView?(tableView, viewForFooterInSection: section)
    }
    
}
