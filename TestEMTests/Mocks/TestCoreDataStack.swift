//
//  TestCoreDataStack.swift
//  TestEMTests
//
//  Created by Tamerlan Swift on 03.11.2025.
//

import CoreData
import Combine
@testable import TestEM

class TestCoreDataStack {
    
    static let shared = TestCoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "TodoContainer")
        
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load test store: \(error)")
            }
        }
    }
    
    func createMockTodoEntity(id: Int64, todo: String, completed: Bool = false, userId: Int64) -> TodoEntity {
        
        let entity = TodoEntity(context: context)
        entity.id = id
        entity.todo = todo
        entity.completed = completed
        entity.userId = 26
        entity.description_ = "Test decr"
        entity.addDate = Date()
        
        return entity
    }
    
    func reset() {
        
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            
            do {
            let todos = try context.fetch(fetchRequest)
            for todo in todos {
                context.delete(todo)
            }
            try context.save()
            context.reset()
            } catch {
                    print("Error resetting test database: \(error)")
            }
    }
}
