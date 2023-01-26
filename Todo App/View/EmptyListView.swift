//
//  EmptyListView.swift
//  Todo App
//
//  Created by horiuchi on 2023/01/17.
//

import SwiftUI

struct EmptyListView: View {
    // MARK: - properties
    
//    @State private var isAnimated: Bool = false
    
    let images: [String] = [
    "danceImage",
    "relaxImage",
    "goodImage",
    "eatImage"
    ]
    
    let tips: String = "タスクはありません"
    
    // MARK: - theme
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Image("\(images.randomElement() ?? self.images[0])")
                // 下記の.foregroundColorでは画像の色が変わらない
                // .renderingModeを一番先頭に追加し、オーバーレイで上から色を重ねる感じで使う
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
                
                Text(tips)
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
            } //: vstack
            .padding(.horizontal)
        } //: zstack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("backgroundColor"))
        .ignoresSafeArea(.all)
    }
}

// MARK: - preview

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
//            .environment(\.colorScheme, .dark)
    }
}
