//
//  Module.swift
//  Jobok
//
//  Created by Bogdan Manshilin on 10.05.17.
//  Copyright © 2017 Jobok. All rights reserved.
//

import UIKit

protocol ModuleObject {
    associatedtype CollectionType
    associatedtype ReusableViewType
    associatedtype ActualModule
    
    var reusable: ReusableViewType { set get }
    var preparations: (CollectionType) -> Void { get }
    var collection: CollectionType? { set get }
    var section: Int { set get }
    
    init(module: ActualModule, section: Int)
    
    func rowsCount() -> Int
    func reload()
    func didSelect(row: Int)
}
