//
//  TodosDataService.swift
//  TestEM
//
//  Created by Tamerlan Swift on 25.10.2025.
//

import Foundation
import SwiftUI
import Combine

class TodosDataService {
    
    @Published var allTodos: [Todo] = []
    
    var todoSubs: AnyCancellable?
    
    init() {
        getTodos()
    }
    
    private func getTodos() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        todoSubs = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(handleOutput)
            .decode(type: Root.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: hundleCompletion, receiveValue: { [weak self] rootClass in
                self?.allTodos = rootClass.todos.enumerated().map { i, todo in
                    Todo(id: todo.id,
                         todo: todo.todo,
                         completed: todo.completed,
                         userId: todo.id,
                         description: "Пример задачи #\(i+1)")
                }
            })

    }
    
    private func hundleCompletion(completion: Subscribers.Completion<any Error>) {
        switch completion {
        case .finished :
            break
        case .failure(let error) :
            if let decodingError = error as? DecodingError {
                switch decodingError {
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context)")
                    case .keyNotFound(let key, let context):
                        print("Key '\(key)' not found: \(context)")
                    case .typeMismatch(let type, let context):
                        print("Type '\(type)' mismatch: \(context)")
                    case .valueNotFound(let value, let context):
                        print("Value '\(value)' not found: \(context)")
                    default:
                        print("Unknown decoding error")
                    }
            }
        }
    }
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
    
    private func rootClassToTodo(rootClass: Root) -> [Todo] {
        rootClass.todos
    }
    
    func cancel() {
        todoSubs?.cancel()
    }
}
