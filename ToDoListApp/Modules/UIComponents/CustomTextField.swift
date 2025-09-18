//
//  CustomTextField.swift
//  ToDoListApp
//
//  Created by Ulugbek Ilhomov on 16/09/25.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .padding(4)
            if text.isEmpty {
                Text("Введите описание...")
                    .padding(.top, 0)
                    .padding(.leading, 12)
                    .frame(minHeight: 50)
                    .foregroundColor(.secondary)
                    .background(Color.clear)
            }
        }
    }
}
