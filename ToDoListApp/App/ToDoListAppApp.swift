//
//  ToDoListAppApp.swift
//  ToDoListApp
//
//  Created by Ulugbek Ilhomov on 13/09/25.
//

import SwiftUI
import CoreData


@main
struct ToDoListAppApp: App {
    var body: some Scene {
        WindowGroup {
            let interactor = ToDoListInteractor()
            let router = ToDoRouter(interactor: interactor)
            let presenter = ToDoListPresenter(interactor: interactor, router: router)
            ToDoList(presenter: presenter, router: router)
        }
    }
}
