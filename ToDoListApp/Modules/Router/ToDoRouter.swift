//
//  ToDoRouter.swift
//  ToDoListApp
//
//  Created by Ulugbek Ilhomov on 18/09/25.
//

import Foundation
import SwiftUI

final class ToDoRouter {
    private let interactor: ToDoListInteractor
    
    init(interactor: ToDoListInteractor) {
        self.interactor = interactor
    }
    
    func makeEditToDoView(entity: ToDoEntity) -> some View {
        let presenter = EditToDoPresenter(entity: entity, interactor: interactor, router: self)
        return EditToDoView(presenter: presenter)
    }
}
