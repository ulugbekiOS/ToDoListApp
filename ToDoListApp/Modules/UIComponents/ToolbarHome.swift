//
//  ToolbarHome.swift
//  ToDoListApp
//
//  Created by Ulugbek Ilhomov on 16/09/25.
//

import SwiftUI

struct ToolbarHome: ToolbarContent {
    
    let action: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                action()
            } label: {
                Image.assets.edit
                    .frame(width: 24, height: 24)
            }
        }
    }
}
