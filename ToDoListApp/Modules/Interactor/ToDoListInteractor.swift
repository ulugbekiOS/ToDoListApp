//
//  ToDoListInteractor.swift
//  ToDoListApp
//
//  Created by Ulugbek Ilhomov on 18/09/25.
//

import Foundation
import CoreData

protocol ToDoListInteracting{
    
    var searchText: String { get set }
    var filteredEntities: [ToDoEntity] { get }
    func slideDelete(indexSet: IndexSet)
    func createNewTodo() -> ToDoEntity
    func editToDo(entity: ToDoEntity, newTaskDescription: String)
    func deleteToDo(entity: ToDoEntity)
    func fetchTodosFromAPI() async
    
}

final class ToDoListInteractor: ToDoListInteracting{
    
    @Published var savedEntities: [ToDoEntity] = []
    let container: NSPersistentContainer
    private let containerName: String = "TodoContainer"
    private let entityName: String = "ToDoEntity"
    var searchText: String = ""
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data! ❌ \(error)")
            } else {
                self.getTodoList()
                if self.savedEntities.isEmpty {
                    Task { await self.fetchTodosFromAPI() }
                }
            }
        }
    }
    
    var filteredEntities: [ToDoEntity]{
        if searchText.isEmpty {
            return savedEntities
        } else {
            return savedEntities.filter { entity in
                (entity.taskDescription ?? "")
                    .localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func slideDelete(indexSet: IndexSet) {
        for index in indexSet {
            let entity = filteredEntities[index]
            container.viewContext.delete(entity)
        }
        applyChanges()
    }
    
    func createNewTodo() -> ToDoEntity {
        let entity = ToDoEntity(context: container.viewContext)
        entity.id = Int32((savedEntities.last?.id ?? 0) + 1)
        entity.completed = false
        entity.savedDate = Date()
        applyChanges()
        return entity
    }
    
    func editToDo(entity: ToDoEntity, newTaskDescription: String) {
        if newTaskDescription.isEmpty {
            deleteToDo(entity: entity)
        } else {
            entity.taskDescription = newTaskDescription
            entity.completed = false
            entity.savedDate = Date()
            applyChanges()
        }
    }
    
    func deleteToDo(entity: ToDoEntity) {
        let context = container.viewContext
        context.delete(entity)
        do {
            try context.save()
            getTodoList()
        } catch {
            print("❌ Error deleting entity: \(error)")
        }
    }
    
    func fetchTodosFromAPI() async {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            try JSONDecoder()
                .decode(ToDoModel.self, from: data)
                .todos?
                .forEach(savingToCore)
        } catch {
            print("API fetch failed: ❌ ", error)
        }
    }
    
    private func getTodoList() {
        let request = NSFetchRequest<ToDoEntity>(entityName: entityName)
        let sort = NSSortDescriptor(keyPath: \ToDoEntity.savedDate, ascending: false)
        request.sortDescriptors = [sort]
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching Todo Entities! ❌ \(error)")
        }
    }
    
    private func savingToCore(toDoModel: Todo) {
        container.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            
            let request = NSFetchRequest<ToDoEntity>(entityName: entityName)
            request.predicate = NSPredicate(format: "id == %d", toDoModel.id)
            
            do {
                let existing = try context.fetch(request)
                if !existing.isEmpty {
                    print("⚠️ Todo with id \(toDoModel.id) already exists, skipping...")
                    return
                }
            } catch {
                print("Error checking duplicates: \(error) ❌")
            }
            
            let entity = ToDoEntity(context: context)
            entity.id = Int32(toDoModel.id)
            entity.completed = toDoModel.completed
            entity.taskDescription = toDoModel.todo ?? nil
            entity.savedDate = Date()
            
            do {
                try context.save()
                Task { @MainActor in self.getTodoList() }
            } catch {
                print("Error saving in background: \(error) ❌")
            }
        }
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving Todo Entities! ❌ \(error)")
        }
    }
    
    func applyChanges() {
        save()
        getTodoList()
    }
    
}
