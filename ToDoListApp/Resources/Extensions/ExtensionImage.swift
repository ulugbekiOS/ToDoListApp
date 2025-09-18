//
//  ExtensionImage.swift
//  ToDoListApp
//
//  Created by Ulugbek Ilhomov on 14/09/25.
//

import Foundation
import SwiftUI

extension Image{
    static let assets = ImageTheme()
}

struct ImageTheme{
    let circle = Image("circle")
    let tickedCircle = Image("tickedCircle")
    let edit = Image("edit")
}
