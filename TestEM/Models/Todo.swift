//
//  Todo.swift
//  TestEM
//
//  Created by Tamerlan Swift on 25.10.2025.
//

import Foundation

// DummyJSON API info
/*
 JSON Response:
 {
   "todos": [
     {
       "id": 1,
       "todo": "Do something nice for someone I care about",
       "completed": true,
       "userId": 26
     }
   ],
   "total": 150,
   "skip": 0,
   "limit": 30
 }
 */

struct Todo: Identifiable, Codable{
    let id: Int
    var todo: String
    var completed: Bool
    let userId: Int
    
    var addDate: Date = Date()
    var description: String?
    
    enum CodingKeys: String, CodingKey {
         case id, todo, completed, userId
     }
}

struct Root: Codable {
    var todos: [Todo]
    let total: Int
    let skip: Int
    let limit: Int
}
