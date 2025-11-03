//
//  TodoDataService.swift
//  TestEM
//
//  Created by Tamerlan Swift on 25.10.2025.
//

import CoreData
import Combine

class TodoDataService: DataService {
 
    private let container: NSPersistentContainer
    private let containerName: String = "TodoContainer"
    private var cancellables = Set<AnyCancellable>()
    private let backgroundQueue = DispatchQueue(label: "com.todos.background", qos: .userInitiated)
    
    @Published var allTodos: [TodoEntity] = []
    var allTodosPublisher: AnyPublisher<[TodoEntity], Never> {
            $allTodos.eraseToAnyPublisher()
        }

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { [weak self] _, _ in
            self?.getTodos()
            self?.loadInitialDataIfNeeded()
        }
    }

    // MARK: - Public Methods
    

    func addTodo(todo: String, description: String?) {
        backgroundQueue.async { [weak self] in
            
            guard let self = self else { return }
            
            let entity = TodoEntity(context: self.container.viewContext)
            entity.id = Int64(UUID().hashValue)
            entity.todo = todo
            entity.completed = false
            entity.userId = 26
            entity.description_ = description
            entity.addDate = Date()
            self.applyChanges()
        }
        
    }

    func updateTodo(_ entity: TodoEntity, todo: String?, description: String?) {
        backgroundQueue.async { [weak self] in
            if let todo = todo { entity.todo = todo }
            if let description = description { entity.description_ = description }
            self?.applyChanges()
        }
    }

    func toggleCompleted(_ entity: TodoEntity) {
        backgroundQueue.async { [weak self] in
            entity.completed.toggle()
            self?.applyChanges()
        }
    }

    func deleteTodo(_ entity: TodoEntity) {
        backgroundQueue.async { [weak self] in
            self?.container.viewContext.delete(entity)
            self?.applyChanges()
        }
    }

    // MARK: - Private Methods
    
    private func getTodos() {
        backgroundQueue.async { [weak self] in
            
            guard let self = self else { return }
            
            let request = NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
            request.sortDescriptors = [NSSortDescriptor(keyPath: \TodoEntity.addDate, ascending: false)]
            
            do {
                let fetchedTodos = try self.container.viewContext.fetch(request)
                
                DispatchQueue.main.async {
                    self.allTodos = fetchedTodos
                }
            } catch {
                print("Error fetching todos: \(error)")
            }
        }
    }
    
    private func applyChanges() {
        backgroundQueue.async { [weak self] in
            self?.save()
            DispatchQueue.main.async {
                self?.getTodos()
            }
        }
    }

    private func save() {
        guard container.viewContext.hasChanges else { return }
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving todos: \(error)")
        }
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


