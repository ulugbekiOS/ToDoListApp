//
//  TodoModel.swift
//  ToDoListApp
//
//  Created by Ulugbek Ilhomov on 13/09/25.
//

import Foundation

struct ToDoModel: Decodable {
    let todos: [Todo]?
}

struct Todo: Identifiable, Decodable {
    let id: Int
    let todo: String?
    let completed: Bool
    let dateOfAdding: Date?
}
