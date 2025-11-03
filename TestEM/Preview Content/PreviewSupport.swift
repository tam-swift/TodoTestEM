//
//  PreviewSupport.swift
//  TestEM
//
//  Created by Tamerlan Swift on 26.10.2025.
//

import Foundation

class PreviewSupport {
    
    static let instance = PreviewSupport()
    
    let todos: [Todo] = [
        Todo(id: 1,
             todo: "Выйти на пробежку",
             completed: false,
             userId: 20),
        Todo(id: 2,
             todo: "Купить продукты",
             completed: true,
             userId: 20,
             description: "Яйца, молоко, хлеб")]
    
    private init() {}
}
