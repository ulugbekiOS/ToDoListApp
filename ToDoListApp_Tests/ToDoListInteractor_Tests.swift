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
        // Act
        let todo = interactor.createNewTodo()
        
        // Assert
        XCTAssertNotNil(todo)
        XCTAssertEqual(todo.completed, false)
        XCTAssertNotNil(todo.savedDate)
    }
    
    func testEditTodoUpdatesDescription() {
        // Arrange
        let todo = interactor.createNewTodo()
        
        // Act
        interactor.editToDo(entity: todo, newTaskDescription: "New Task")
        
        // Assert
        XCTAssertEqual(todo.taskDescription, "New Task")
        XCTAssertEqual(todo.completed, false)
    }
    
    func testDeleteTodoRemovesEntity() {
        // Arrange
        let todo = interactor.createNewTodo()
        interactor.applyChanges()
        let initialCount = interactor.savedEntities.count
        
        // Act
        interactor.deleteToDo(entity: todo)
        
        // Assert
        XCTAssertLessThan(interactor.savedEntities.count, initialCount)
    }
    
    func testFilteredEntitiesWithSearchText() {
        // Arrange
        let todo1 = interactor.createNewTodo()
        todo1.taskDescription = "Buy milk"
        let todo2 = interactor.createNewTodo()
        todo2.taskDescription = "Go gym"
        interactor.applyChanges()
        
        interactor.searchText = "milk"
        
        // Act
        let filtered = interactor.filteredEntities
        
        // Assert
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.taskDescription, "Buy milk")
    }
}
