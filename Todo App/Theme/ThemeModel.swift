//
//  ThemeModel.swift
//  Todo App
//
//  Created by 堀内大希 on 2023/01/18.
//

import SwiftUI

// MARK: - Theme model

struct Theme: Identifiable {
    let id: Int
    let themeName: String
    let themeColor: Color
}
