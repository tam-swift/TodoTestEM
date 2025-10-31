//
//  TodoDataService.swift
//  TestEM
//
//  Created by Tamerlan Swift on 25.10.2025.
//

import Foundation
import CoreData
import Combine

class TodoDataService {
    
    
    
    private let container: NSPersistentContainer
    private let containerName: String = "TodoContainer"
    private var cancellables = Set<AnyCancellable>()
    
    @Published var allTodos: [TodoEntity] = []

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { [weak self] _, _ in
            self?.getTodos()
            self?.loadInitialDataIfNeeded()
        }
    }

    // MARK: - Public Methods
    func getTodos() {
        let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TodoEntity.addDate, ascending: false)]
        
        do {
            allTodos = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching todos: \(error)")
        }
    }

    func addTodo(title: String, description: String?) {
        let entity = TodoEntity(context: container.viewContext)
        entity.id = Int64(UUID().hashValue)
        entity.todo = title
        entity.completed = false
        entity.userId = 20
        entity.description_ = description
        entity.addDate = Date()
        applyChanges()
    }

    func updateTodo(_ entity: TodoEntity, title: String?, description: String?) {
        if let title = title { entity.todo = title }
        if let description = description { entity.description_ = description }
        applyChanges()
    }

    func toggleCompleted(_ entity: TodoEntity) {
        entity.completed.toggle()
        applyChanges()
    }

    func deleteTodo(_ entity: TodoEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }

    func resetInitialData() {
        UserDefaults.standard.set(false, forKey: "hasInitialDataLoaded")
        allTodos.forEach { container.viewContext.delete($0) }
        applyChanges()
        loadInitialDataIfNeeded()
    }

    // MARK: - Private Methods
    private func applyChanges() {
        save()
        getTodos()
    }

    private func save() {
        guard container.viewContext.hasChanges else { return }
        try? container.viewContext.save()
    }

    private func loadInitialDataIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: "hasInitialDataLoaded") else { return }
        loadFromAPI()
    }

    private func loadFromAPI() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Root.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error loading from API: \(error)")
                }
            } receiveValue: { [weak self] root in
                self?.saveAPIData(root.todos)
                UserDefaults.standard.set(true, forKey: "hasInitialDataLoaded")
                print("Loaded \(root.todos.count) todos from API")
            }
            .store(in: &cancellables)
    }

    private func saveAPIData(_ todos: [Todo]) {
        let context = container.viewContext
        
        for (index, todo) in todos.enumerated() {
            let entity = TodoEntity(context: context)
            entity.id = Int64(todo.id)
            entity.todo = todo.todo
            entity.completed = todo.completed
            entity.userId = Int64(todo.userId)
            entity.description_ = "Пример задачи #\(index + 1)"
            entity.addDate = Date()
        }
        
        applyChanges()
    }
}
