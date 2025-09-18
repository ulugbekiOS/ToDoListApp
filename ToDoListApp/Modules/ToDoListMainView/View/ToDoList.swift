//
//  SwiftUIView.swift
//  ToDoListApp
//
//  Created by Ulugbek Ilhomov on 13/09/25.
//


import SwiftUI

struct ToDoList: View {
    
    @StateObject private var presenter: ToDoListPresenter
    private let router: ToDoRouter
    
    init(presenter: ToDoListPresenter, router: ToDoRouter) {
        _presenter = StateObject(wrappedValue: presenter)
        self.router = router
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(presenter.filteredTodos, id: \.objectID) { entity in
                    VStack(spacing: 0) {
                        ToDoRow(entity: entity, presenter: presenter)
                        Rectangle()
                            .fill(Color.ticked)
                            .frame(height: 0.5)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .padding(.top, 8)
                    }
                    .padding(.top, 8)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                .onDelete(perform: presenter.slideDelete)
            }
            .listStyle(.plain)
            .navigationTitle("Задачи")
            .searchable(
                text: $presenter.searchText,
                placement: .sidebar,
                prompt: "Search"
            )
            .toolbar {
                ToolbarHome {
                    presenter.createNewTodo()
                }
            }
            .navigationDestination(isPresented: $presenter.isPresentingEditView) {
                if let todo = presenter.selectedToDo {
                    router.makeEditToDoView(entity: todo)
                }
            }
        }
    }
}
