//
//  DataSeviceProtocol.swift
//  TestEM
//
//  Created by Tamerlan Swift on 03.11.2025.
//

import CoreData
import Combine

protocol DataService {
    
    var allTodos: [TodoEntity] { get }
    var allTodosPublisher: AnyPublisher<[TodoEntity], Never> { get }
    
    func addTodo(todo: String, description: String?)
    func updateTodo(_ entity: TodoEntity, todo: String?, description: String?)
    func toggleCompleted(_ entity: TodoEntity)
    func deleteTodo(_ entity: TodoEntity)
}
