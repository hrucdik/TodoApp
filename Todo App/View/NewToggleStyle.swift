//
//  NewToggleStyle.swift
//  Todo App
//
//  Created by horiuchi on 2023/01/25.
//

import SwiftUI

struct NewToggleStyle: ToggleStyle {
    
    // MARK: - properties

    static let backgroundColor = Color(.label)
    static let switchColor = Color(.systemBackground)

    // MARK: - function
    
    func makeBody(configuration: Configuration) -> some View {

        HStack {

            configuration.label

            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 50, height: 30, alignment: .center)
                .overlay((
                    Image(systemName: configuration.isOn ? "xmark.circle.fill" : "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(configuration.isOn ? NewToggleStyle.switchColor : .white)
                        .padding(3)
                        .offset(x: configuration.isOn ? 10 : -10, y: 0)
                        .animation(.linear, value: configuration.isOn)
                ))
                .foregroundColor(configuration.isOn ? NewToggleStyle.backgroundColor : .green)
                .onTapGesture(perform: {
                    configuration.isOn.toggle()
                })

        } //: hstack

    }

}


