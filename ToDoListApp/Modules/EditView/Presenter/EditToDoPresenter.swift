//
//  EditToDoPresenter.swift
//  ToDoListApp
//
//  Created by Ulugbek Ilhomov on 18/09/25.
//


import SwiftUI
import CoreData

final class EditToDoPresenter: ObservableObject {
    
    private let interactor: ToDoListInteractor
    private let router: ToDoRouter
    private let entity: ToDoEntity
    @Published var taskDescription: String = ""
    
    init(entity: ToDoEntity, interactor: ToDoListInteractor, router: ToDoRouter) {
        self.entity = entity
        self.interactor = interactor
        self.router = router
    }
    
    var savedDateText: String {
        entity.savedDate?.formatted(
            .dateTime.day(.twoDigits).month(.twoDigits).year(.twoDigits)
        ) ?? ""
    }
    
    func loadInitialData() {
        taskDescription = entity.taskDescription ?? ""
    }
    
    func saveChanges() {
        if taskDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        interactor.editToDo(entity: entity, newTaskDescription: taskDescription)
    }
    
    func dismiss(_ dismissAction: DismissAction) {
        dismissAction()
    }
}
