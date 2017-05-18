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
    weak var scrollDelegate: UIScrollViewDelegate?
    
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

extension ModulledTable {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidZoom?(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollDelegate?.viewForZooming?(in: scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return scrollDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? false
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollDelegate?.scrollViewDidScrollToTop?(scrollView)
    }

}
