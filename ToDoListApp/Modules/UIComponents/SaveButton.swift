//
//  SaveButton.swift
//  ToDoListApp
//
//  Created by Ulugbek Ilhomov on 16/09/25.
//

import SwiftUI

struct SaveButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.defaultYellow)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                Text("Сохранить")
                    .foregroundColor(Color.black)
                    .font(.system(size: 18, weight: .semibold))
            }
        }
    }
}

