//
//  TodosViewModel.swift
//  TestEM
//
//  Created by Tamerlan Swift on 25.10.2025.
//

import Foundation
import Combine

class TodosViewModel: ObservableObject {
    
    @Published var todos: [Todo] = []
    @Published var searchText: String = ""
    
    private let todoDataService : DataService
    private var cancellables = Set<AnyCancellable>()
    private let backgroundQueue = DispatchQueue(label: "com.todos.filter", qos: .userInitiated)
    
    init(todoDataService: DataService = TodoDataService()) {
        self.todoDataService = todoDataService
        addSubscribers()
    }
    
    // MARK: - PRIVATE
    private func addSubscribers() {
        // Subscribe to search text
        $searchText
            .combineLatest(todoDataService.allTodosPublisher)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searchText, todosEnt in
                self?.filterTodos(todoEntities: todosEnt, searchText: searchText)
            }
            .store(in: &cancellables)
        
    }
    
    private func filterTodos(todoEntities: [TodoEntity], searchText: String) {
           backgroundQueue.async { [weak self] in
               
               let todos = todoEntities.map { entity in
                   Todo(
                       id: Int(entity.id),
                       todo: entity.todo ?? "",
                       completed: entity.completed,
                       userId: Int(entity.userId),
                       addDate: entity.addDate ?? Date(),
                       description: entity.description_
                   )
               }
               
               let filteredTodos: [Todo]
               
               if searchText.isEmpty {
                   filteredTodos = todos
               } else {
                   let lowercasedText = searchText.lowercased()
                   filteredTodos = todos.filter { todo in
                       todo.todo.lowercased().contains(lowercasedText) ||
                       (todo.description?.lowercased().contains(lowercasedText) ?? false)
                   }
               }
               
               DispatchQueue.main.async {
                   self?.todos = filteredTodos
               }
           }
       }
    
    // MARK: - PUBLIC
    func addTodo(todo: String, description: String?) {
        todoDataService.addTodo(todo: todo, description: description)
    }
    
    func updateTodo(_ todo: Todo, title: String? = nil, description: String? = nil) {
        if let entity = todoDataService.allTodos.first(where: { $0.id == Int64(todo.id) }) {
            todoDataService.updateTodo(entity, todo: title, description: description)
        }
    }
    
    func toggleCompleted(_ todo: Todo) {
        
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
                    var updatedTodo = todos[index]
                    updatedTodo.completed.toggle()
                    todos[index] = updatedTodo
        }
                
        if let entity = todoDataService.allTodos.first(where: { $0.id == Int64(todo.id) }) {
            todoDataService.toggleCompleted(entity)
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        
        todos.removeAll { $0.id == todo.id }
        
        if let entity = todoDataService.allTodos.first(where: { $0.id == Int64(todo.id) }) {
            todoDataService.deleteTodo(entity)
        }
    }
    
    func getTodo(by id: Int) -> Todo? {
        return todos.first { $0.id == id }
    }
}
