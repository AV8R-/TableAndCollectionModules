//
//  CollectionViewModule.swift
//  UltimateGuitar
//
//  Created by admin on 3/21/17.
//
//

import UIKit

protocol Reusable {
    associatedtype CollectionType
    var `class`: AnyClass? { get }
    var nib: UINib? { get }
    var identifier: String { get }
    func register(for collection: CollectionType)
}

enum CollectionReusable: Reusable {
    typealias CollectionType = UICollectionView
    
    case `class`(AnyClass)
    case nibName(String)
    
    class Bundler {}
    
    var `class`: AnyClass? {
        switch self {
        case let .class(cl): return cl
        default: return nil
        }
    }
    
    var nib: UINib? {
        let bundle = Bundle(for: Bundler.self)
        switch self {
        case let .nibName(nib):
            return UINib(nibName: nib, bundle: bundle)
        case let .class(cl):
            let nibName = NSStringFromClass(cl)
            if let _ = bundle.path(forResource: nibName, ofType: "nib") {
                return UINib(nibName: nibName, bundle: bundle)
            } else {
                return nil
            }
        }
    }
    
    var identifier: String {
        switch self {
        case let .class(c): return NSStringFromClass(c)
        case let .nibName(name): return name
        }
    }
    
    func register(for collection: CollectionType) {
        if let nib = nib {
            collection.register(nib, forCellWithReuseIdentifier: identifier)
        } else if let clss = `class` {
            collection.register(clss, forCellWithReuseIdentifier: identifier)
        } else {
            fatalError("Module must register reusable cell with either class or nib")
        }
    }
}

enum TableReusable: Reusable {
    typealias CollectionType = UITableView
    
    case `class`(AnyClass)
    case nibName(String)
    
    class Bundler {}
    
    var `class`: AnyClass? {
        switch self {
        case let .class(cl): return cl
        default: return nil
        }
    }
    
    var nib: UINib? {
        let bundle = Bundle(for: Bundler.self)
        switch self {
        case let .nibName(nib):
            return UINib(nibName: nib, bundle: bundle)
        case let .class(cl):
            let nibName = NSStringFromClass(cl)
            if let _ = bundle.path(forResource: nibName, ofType: "nib") {
                return UINib(nibName: nibName, bundle: bundle)
            } else {
                return nil
            }
        }
    }
    
    var identifier: String {
        switch self {
        case let .class(c): return NSStringFromClass(c)
        case let .nibName(name): return name
        }
    }
    
    func register(for collection: CollectionType) {
        if let nib = nib {
            collection.register(nib, forCellReuseIdentifier: identifier)
        } else if let clss = `class` {
            collection.register(clss, forCellReuseIdentifier: identifier)
        } else {
            fatalError("Module must register reusable cell with either class or nib")
        }
    }

}
