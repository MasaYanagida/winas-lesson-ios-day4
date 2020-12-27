//
//  RealmService.swift
//  Day4Homework
//
//  Created by Rasel on 2020/12/28.
//

import RealmSwift

final class RealmService {
    
    static let shared: RealmService = RealmService()
    private var database: Realm?
    
    private init() {
        database = try? Realm()
    }
    
    func add(object: Object) {
        try? database?.write {
            database?.add(object, update: .all)
        }
    }
    
    func delete<T: Object>(dataType: T.Type) {
        guard let oldObjects = database?.objects(dataType) else {
            fatalError("Data not exists")
        }
        try? database?.write {
            database?.delete(oldObjects)
        }
    }
    
    func fetch<T: Object>(dataType: T.Type) -> Results<T> {
        guard let result = database?.objects(dataType) else {
            fatalError("Failed to fetch data from realm")
        }
        return result
    }
}
