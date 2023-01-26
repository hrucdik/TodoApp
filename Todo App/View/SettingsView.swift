//
//  SettingsView.swift
//  Todo App
//
//  Created by horiuchi on 2023/01/18.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - properties
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - theme
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared
    @State private var isThemeChanged: Bool = false
    
    // MARK: - body
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 0) {
                // MARK: - form
                
                Form {
                    // MARK: - section 1
                    
                    Section {
                        List {
                            ForEach(themes, id: \.id) { item in
                                Button {
                                    // どれかのテーマを押したらlocal storageに保存する処理
                                    self.theme.themeSettings = item.id
                                    UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                                    self.isThemeChanged.toggle()
                                } label: {
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.themeColor)
                                        
                                        Text(item.themeName)
                                    } //: hstack
                                } //: button
                                .tint(Color.primary)
                            } //: foreach
                        } //: list
                    } header: {
                        HStack {
                            Text("テーマカラーを選択")
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 13, height: 13)
                                .foregroundColor(themes[self.theme.themeSettings].themeColor)
                        }
                    }
                    .padding(.vertical, 3)
                    .alert(Text("カラーを変更しました"), isPresented: $isThemeChanged) {
                        Button(role: .cancel) {
                            
                        } label: {
                            Text("OK")
                        }
                    }
                } //: form
                .scrollContentBackground(.hidden)
                .background(Color("backgroundColor"))
                .listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                
            } //: vstack
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    } //: button
                }
            }) //: toolbar
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.automatic)
            //            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color("backgroundColor").ignoresSafeArea(.all))
            
            
        } //: navigation
        
        .tint(themes[self.theme.themeSettings].themeColor)
    }
}

// MARK: - preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
