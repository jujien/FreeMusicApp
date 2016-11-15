//
//  Database.swift
//  FreeMusicApp
//
//  Created by Vũ Kiên on 07/11/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class Database {
    static var `default`: Database = Database()
    
    var realm: Realm?
    
    fileprivate init() {
        do {
            realm = try Realm()
        } catch {
            print("error: \(error.localizedDescription)")
        }
        
    }
    
    func lists<T: Object>(array: [T]) -> List<T> {
        return List<T>(array)
    }
    
    func array<T: Object>(list: List<T>) -> [T] {
        return Array<T>(list)
    }
    
    func addList<T: Object>(array: [T]) throws {
        for element in array {
            try add(object: element)
        }
    }
    
    func add(object: Object, update: Bool = true) throws {
        guard let realm = self.realm else {
            return
        }
        
        try realm.write {
            realm.add(object, update: update)
            print("complete")
        }
    }
    
    func update(_ update: @escaping () -> Void) throws {
        guard let realm  = self.realm else {
            return
        }
        
        try realm.write {
            update()
        }
    }
    
    func results<T: Object>(type: T.Type, filter: String? = nil) -> [T]? {
        guard let realm = self.realm else {
            return nil
        }
        guard !realm.objects(type).isEmpty else {
            return nil
        }
        guard let filter = filter else {
            return Array(realm.objects(type))
        }
        let lists = realm.objects(type).filter(filter)
        return Array<T>(lists)
    }
    
    func results<T: Object>(type: T.Type, id: Int) -> T? {
        guard let realm = self.realm else {
            return nil
        }
        
        guard let object = realm.object(ofType: type, forPrimaryKey: id) else {
            return nil
        }
        
        return object
    }
    
    func delete(object: Object? = nil, isAll: Bool = false) throws {
        try realm?.write {
            if !isAll {
                realm?.delete(object!)
            } else {
                realm?.deleteAll()
            }
        }
    }
    
    func delete<T: Object>(lists: List<T>) throws {
        try realm?.write {
            realm?.delete(lists)
        }
    }
    
    
    func path() -> String {
        return Realm.Configuration.defaultConfiguration.fileURL!.absoluteString
    }
}
