//
//  TodoDataService_Tests.swift
//  ToDoListApp_Tests
//
//  Created by Ulugbek Ilhomov on 17/09/25.
//

import XCTest
@testable import ToDoListApp

final class ToDoListInteractorTests: XCTestCase {
    
    var interactor: ToDoListInteractor!
    
    override func setUp() {
        super.setUp()
        interactor = ToDoListInteractor()
    }
    
    override func tearDown() {
        interactor = nil
        super.tearDown()
    }
    
    func testCreateNewTodo() {
        let todo = interactor.createNewTodo()
        XCTAssertNotNil(todo)
        XCTAssertEqual(todo.completed, false)
        XCTAssertNotNil(todo.savedDate)
    }
    
    func testEditTodoUpdatesDescription() {
        let todo = interactor.createNewTodo()
        interactor.editToDo(entity: todo, newTaskDescription: "New Task")
        XCTAssertEqual(todo.taskDescription, "New Task")
        XCTAssertEqual(todo.completed, false)
    }
    
    func testDeleteTodoRemovesEntity() {
        let todo = interactor.createNewTodo()
        interactor.applyChanges()
        let initialCount = interactor.savedEntities.count
        interactor.deleteToDo(entity: todo)
        XCTAssertLessThan(interactor.savedEntities.count, initialCount)
    }
    
    func testFilteredEntitiesWithSearchText() {
        let todo1 = interactor.createNewTodo()
        todo1.taskDescription = "Buy milk"
        let todo2 = interactor.createNewTodo()
        todo2.taskDescription = "Go gym"
        interactor.applyChanges()
        interactor.searchText = "milk"
        let filtered = interactor.filteredEntities
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.taskDescription, "Buy milk")
    }
}
