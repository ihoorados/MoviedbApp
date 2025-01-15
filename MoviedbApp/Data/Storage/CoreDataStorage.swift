//
//  CoreDataStorage.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/15/25.
//

import CoreData

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}
