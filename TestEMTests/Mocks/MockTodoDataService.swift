//
//  MockTodoDataService.swift
//  TestEMTests
//
//  Created by Tamerlan Swift on 03.11.2025.
//

import CoreData
import Combine
@testable import TestEM

class MockTodoDataService: DataService {
    
    @Published var allTodos: [TodoEntity] = []
    
    var allTodosPublisher: AnyPublisher<[TodoEntity], Never> {
        $allTodos.eraseToAnyPublisher()
    }
    
    private var mockEntities: [TodoEntity] = []
    
    
    var addTodoCallCount = 0
    var updateTodoCallCount = 0
    var toggleCompletedCallCount = 0
    var deleteTodoCallCount = 0
    
    var lastAddedtodo: String?
    var lastAddedDescription: String?
    var lastUpdatedTodo: String?
    var lastUpdatedDescription: String?
    
    var lastToggledEntity: TodoEntity?
    var lastDeletedEntity: TodoEntity?
    var lastUpdatedEntity: TodoEntity?
    
    
    init(mockEntities: [TodoEntity] = [] ) {
            self.mockEntities = mockEntities
            self.allTodos = mockEntities
        }
    
    func addTodo(todo: String, description: String?) {
        addTodoCallCount += 1
        lastAddedtodo = todo
        lastAddedDescription = description
        
        let mockEntity = TodoEntity(context: TestCoreDataStack.shared.context)
        mockEntity.id = Int64(allTodos.count + 1)
        mockEntity.todo = todo
        mockEntity.description_ = description
        mockEntity.completed = false
        mockEntity.userId = 20
        mockEntity.addDate = Date()
        
        allTodos.append(mockEntity)
    }
    
    func updateTodo(_ entity: TodoEntity, todo: String?, description: String?) {
        
        updateTodoCallCount += 1
        lastUpdatedTodo = todo
        lastUpdatedDescription  = description
        lastUpdatedEntity = entity
        
        if let todo = todo { entity.todo = todo }
        if let descr = description { entity.description_ = descr }
        
        allTodos = mockEntities
    }
    
    func toggleCompleted(_ entity: TodoEntity) {
        toggleCompletedCallCount += 1
        lastToggledEntity = entity
        entity.completed.toggle()
        allTodos = mockEntities
    }
    
    func deleteTodo(_ entity: TodoEntity) {
        deleteTodoCallCount += 1
        lastDeletedEntity = entity
        
        if let index = mockEntities.firstIndex(where: { $0.id == entity.id }) {
            mockEntities.remove(at: index)
            allTodos = mockEntities
        }
    }
}
