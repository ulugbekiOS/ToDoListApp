//
//  ToDoListPresenter.swift
//  ToDoListApp
//
//  Created by Ulugbek Ilhomov on 18/09/25.
//

import SwiftUI
import CoreData

final class ToDoListPresenter: ObservableObject {
    
    private let interactor: ToDoListInteractor
    private let router: ToDoRouter
    
    @Published var filteredTodos: [ToDoEntity] = []
    @Published var selectedToDo: ToDoEntity?
    @Published var isPresentingEditView: Bool = false
    @Published var searchText: String = "" {
        didSet { updateFilteredTodos() }
    }
    
    init(interactor: ToDoListInteractor, router: ToDoRouter) {
        self.interactor = interactor
        self.router = router
        updateFilteredTodos()
    }
    
    func updateFilteredTodos() {
        interactor.searchText = searchText
        filteredTodos = interactor.filteredEntities
    }
    
    func slideDelete(at indexSet: IndexSet) {
        interactor.slideDelete(indexSet: indexSet)
        updateFilteredTodos()
    }
    
    func delete(entity: ToDoEntity) {
        interactor.deleteToDo(entity: entity)
        updateFilteredTodos()
    }
    
    func createNewTodo() {
        let newToDo = interactor.createNewTodo()
        selectedToDo = newToDo
        isPresentingEditView = true
        updateFilteredTodos()
    }
    
    func navigateToEdit(to entity: ToDoEntity) {
        selectedToDo = entity
        isPresentingEditView = true
    }
    
    func fetchTodosFromAPI() async {
        await interactor.fetchTodosFromAPI()
        updateFilteredTodos()
    }
}
