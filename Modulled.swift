//
//  Modulled.swift
//  UltimateGuitar
//
//  Created by admin on 3/28/17.
//
//

import UIKit

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
