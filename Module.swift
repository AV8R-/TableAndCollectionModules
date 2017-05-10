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
    func numberOfSection(in collection: CollectionType) -> Int
    func collection(_ collection: CollectionType, rowsIn section: Int) -> Int
    func reload()
}
