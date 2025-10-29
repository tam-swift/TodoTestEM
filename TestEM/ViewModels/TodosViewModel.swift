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
    
    private let todosDataService = TodosDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubs()
    }
    
    private func addSubs() {
        $searchText
            .combineLatest(todosDataService.$allTodos)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { text, todos -> [Todo] in
                guard text != "" else { return todos }
                let lowercasedText = text.lowercased()
                return todos.filter { todo in
                    todo.todo.lowercased().contains(lowercasedText) ||
                    ((todo.description?.lowercased().contains(lowercasedText)) != nil)
                }
            }
            .sink { [weak self] returnedTodos in
                self?.todos = returnedTodos
            }
            .store(in: &cancellables)
        
        $todos
            .combineLatest(todosDataService.$allTodos)
            .map {$0.1}
            .sink { [weak self] todos in
                self?.todos = todos
            }
            .store(in: &cancellables)
    }
    
    func getTodo(by id: Int) -> Todo? {
        return todos.first { $0.id == id }
    }
    
    func switchCompleted(todo: Todo) {
        guard let index = todos.firstIndex(where: {$0.id == todo.id}) else { return }
        todos[index].completed.toggle()
    }
    func deleteTodo(todo: Todo) {
        guard let index = todos.firstIndex(where: {$0.id == todo.id}) else { return }
        todos.remove(at: index)
    }
    
    func saveTodo(todo: Todo, name: String, description: String?) {
        guard let index = todos.firstIndex(where: {$0.id == todo.id}) else { return }
            todos[index].todo = name
            todos[index].description = description
    }
    func addTodo(name: String, description: String?) {
            todos.append(Todo(id: UUID().hashValue,
                              todo: name,
                              completed: false,
                              userId: 20,
                              description: description))
    }
    
    func deleteAllTodos() {
        guard !todos.isEmpty else { return }
            todos.removeAll()
        
    }
}
