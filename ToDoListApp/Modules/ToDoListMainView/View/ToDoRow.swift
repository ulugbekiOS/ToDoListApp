//
//  ToDoRow.swift
//  ToDoListApp
//
//  Created by Ulugbek Ilhomov on 16/09/25.
//

import SwiftUI

struct ToDoRow: View {
    @ObservedObject var entity: ToDoEntity
    var presenter: ToDoListPresenter
    
    @State private var isEditing = false
    @State private var confirmDelete = false
    
    var body: some View {
        HStack(alignment: .top) {
            Image(entity.completed ? .tickedCircle : .circle)
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 4)
                .onTapGesture {
                    entity.completed.toggle()
                    try? entity.managedObjectContext?.save()
                }
            VStack(alignment: .leading) {
                Text("Задача")
                    .font(.system(size: 20))
                    .strikethrough(entity.completed, color: Color.ticked)
                    .foregroundStyle(entity.completed ? Color.ticked : Color.text)
                
                Text(entity.taskDescription ?? "No taskDescription")
                    .font(.system(size: 16))
                    .foregroundStyle(entity.completed ? Color.ticked : Color.text)
                    .padding(.bottom, 1)
                
                if let date = entity.savedDate {
                    Text(date.formatted(
                        .dateTime.day(.twoDigits).month(.twoDigits).year(.twoDigits))
                    )
                    .foregroundStyle(entity.completed ? Color.ticked : Color.text)
                    .font(.system(size: 12))
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 3)
        .padding(.horizontal)
        .contextMenu {
            Button {
                presenter.navigateToEdit(to: entity)
            } label: {
                Label("Редактировать", image: .editForMenu)
            }
            
            ShareLink(item: "Hey there, Here is my ToDoListApp") {
                Label("Поделиться", image: .share)
            }
            
            Button(role: .destructive) {
                confirmDelete = true
            } label: {
                Label("Удалить", image: .trash)
            }
        }
        .confirmationDialog("Выберите действие", isPresented: $confirmDelete) {
            Button("Удалить", role: .destructive) {
                withAnimation(.linear) {
                    presenter.delete(entity: entity)
                }
            }
            Button("Отмена", role: .cancel) { }
        }
    }
}
