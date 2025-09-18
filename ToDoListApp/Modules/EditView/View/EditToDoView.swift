//
//  EditToDoView.swift
//  ToDoListApp
//
//  Created by Ulugbek Ilhomov on 16/09/25.
//

import SwiftUI

struct EditToDoView: View {
    @ObservedObject var presenter: EditToDoPresenter
    @Environment(\.dismiss) private var dismissAction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Задача")
                .font(.system(size: 34, weight: .bold))
                .padding(.horizontal, 20)
            
            Text(presenter.savedDateText)
                .padding(.horizontal, 20)
            
            CustomTextField(text: $presenter.taskDescription)
                .padding(.horizontal, 9)
            
            Spacer()
            
            SaveButton {
                presenter.saveChanges()
                presenter.dismiss(dismissAction)
            }
            .padding(20)
        }
        .onAppear {
            presenter.loadInitialData()
        }
    }
}
