//
//  Module.swift
//  Jobok
//
//  Created by Bogdan Manshilin on 10.05.17.
//  Copyright © 2017 Jobok. All rights reserved.
//

import Foundation

protocol ModuleObject {
    associatedtype CollectionType
    associatedtype ReusableViewType
    
    var reusable: ReusableViewType { set get }
    var preparations: (CollectionType) -> Void { get }
    var collection: CollectionType? { set get }
    var section: Int { set get }
    func rowsCount() -> Int
    func reload()
}

protocol ComplexModule: ModuleObject {
    associatedtype Submodule: ModuleObject
    
    var submodules: [Submodule] { set get }
}

extension ComplexModule where Submodule.CollectionType == CollectionType, Submodule.ReusableViewType == ReusableViewType {
    var preparations: (CollectionType) -> Void {
        return { collection in
            self.submodules.forEach { $0.preparations(collection) }
        }
    }
    
    func reload() {
        submodules.forEach { $0.reload() }
    }
}
