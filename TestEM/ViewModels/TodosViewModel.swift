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
    
    private let todoDataService = TodoDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    // MARK: - PRIVATE
    private func addSubscribers() {
        
        // Subscribe to search text
        $searchText
            .combineLatest(todoDataService.$allTodos)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .map(filterAndMapTodos)
            .sink { [weak self] filteredTodos in
                self?.todos = filteredTodos
            }
            .store(in: &cancellables)
        
    }
    
    private func filterAndMapTodos(searchText: String, todoEntities: [TodoEntity]) -> [Todo] {
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
        
        guard !searchText.isEmpty else { return todos }
        
        let lowercasedText = searchText.lowercased()
        return todos.filter { todo in
            todo.todo.lowercased().contains(lowercasedText) ||
            (todo.description?.lowercased().contains(lowercasedText) ?? false)
        }
    }
    
    // MARK: - PUBLIC
    func addTodo(title: String, description: String?) {
        todoDataService.addTodo(title: title, description: description)
    }
    
    func updateTodo(_ todo: Todo, title: String? = nil, description: String? = nil) {
        if let entity = todoDataService.allTodos.first(where: { $0.id == Int64(todo.id) }) {
            todoDataService.updateTodo(entity, title: title, description: description)
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
    
    func refreshTodos() {
            todoDataService.getTodos()
        }
    
}
