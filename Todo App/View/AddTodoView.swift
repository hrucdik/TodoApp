//
//  AddTodoView.swift
//  Todo App
//
//  Created by horiuchi on 2023/01/17.
//

import SwiftUI

struct AddTodoView: View {
    // MARK: - properties
    
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var priority: String = "普通"
    
    let priorities = ["高い", "普通", "低い"]
    
    @State private var errorShowing: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var time: Date = Date()
    @State private var hideDate: Bool = false
    @State private var hidePriority: Bool = false
    
    @FocusState var focus : Bool
    
    // MARK: - theme
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日(E) H時mm分"
        
        return dateFormatter
    }
    
    
    // MARK: - body
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea(.all)
                GeometryReader { _ in
                    VStack {
                        VStack(alignment: .leading, spacing: 20) {
                            // MARK: - todo name
                            TextField("タスクを入力して下さい", text: $name)
                                .padding()
                                .background(Color(UIColor.tertiarySystemFill))
                                .cornerRadius(9)
                                .font(.system(size: 24, weight: .bold, design: .default))
                                .focused($focus)
                            
                            
                            
                            HStack {
                                Spacer()
                                
                                Toggle(hideDate ? "日時(なし)" : "日時(あり)", isOn: $hideDate)
                                    .toggleStyle(NewToggleStyle())
                                
                                Spacer()

                                Toggle(hidePriority ? "重要度(なし)" : "重要度(あり)", isOn: $hidePriority)
                                    .toggleStyle(NewToggleStyle())
//                                    .padding(.trailing, 5)
//                                .padding(.leading, 4)
                                Spacer()
                            }
                        
                            // MARK: - DatePicker
                            
                            ZStack(alignment: .bottomTrailing) {
                                
                                
                                DatePicker("date", selection: $time, in: Date()..., displayedComponents: [.date])
                                // "date" → hidden
                                    .labelsHidden()
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                    .padding(6)
                                    .padding(.bottom, 35)
                                    .background(hideDate ? Color(.gray).opacity(0.4) : Color(UIColor.tertiarySystemFill))
                                    .cornerRadius(9)
                                
                                HStack(spacing: 0) {
                                    
                                    Text("時刻")
                                        .foregroundColor(hideDate ? Color.gray : themes[self.theme.themeSettings].themeColor)
                                    
                                    DatePicker("時刻", selection: $time, in: Date()..., displayedComponents: [.hourAndMinute])
                                        .environment(\.locale, Locale(identifier: "ja_JP"))
                                        .labelsHidden()
                                        .colorInvert()
                                        .colorMultiply(hideDate ? Color.gray : Color.primary)
                                        .padding()
                                        
                                    
                                } //: hstack
                            } //: zstack
                            .disabled(hideDate)
                            
                            // MARK: - todo priority
                            
                            HStack {
                                Text("重要度")
                                    .padding(.leading, 10)
                                    .foregroundColor(hidePriority ? Color.gray : themes[self.theme.themeSettings].themeColor)
                                
                                Spacer()
                                
                                Picker("重要度", selection: $priority) {
                                    ForEach(priorities, id: \.self) {
                                        Text($0)
                                    }
                                } //: picker
                                .pickerStyle(MenuPickerStyle())
                            } //: hstack
                            .disabled(hidePriority)
                            .padding(6)
                            .padding(.vertical, 5)
                            .background(hidePriority ? Color(.gray).opacity(0.4) : Color(UIColor.tertiarySystemFill))
                            .cornerRadius(9)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            
                            // MARK: - save button
                            
                            Button {
                                
                                if self.name != "" {
                                    let todo = Todo(context: self.viewContext)
                                    todo.name = self.name
                                    
                                    if !hideDate && !hidePriority {
                                        // hideDate && hidePriority == false
                                        
                                        todo.priority = self.priority
                                        todo.time = self.dateFormatter.string(from: time)
                                        
                                    } else if !hideDate && hidePriority {
                                        // hideDate == false && hidePriority == true
                                        
                                        todo.priority = ""
                                        todo.time = self.dateFormatter.string(from: time)
                                        
                                    } else if hideDate && !hidePriority {
                                        // hideDate == true && hidePriority == false
                                        
                                        todo.priority = self.priority
                                        todo.time = ""
                                        
                                    } else {
                                        // hideDate && hidePriority == true
                                        
                                        todo.priority = ""
                                        todo.time = ""
                                    }
                                    do {
                                        try self.viewContext.save()
                                    } catch {
                                        print(error)
                                    }
                                } else {
                                    // name == ""
                                    
                                    self.errorShowing = true
                                    self.errorTitle = "タスクが入力されていません"
                                    
                                    return
                                }
                                dismiss()
                                
                            } label: {
                                Text("Save")
                                    .font(.system(size: 24, weight: .bold, design: .default))
                                    .padding()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .background(themes[self.theme.themeSettings].themeColor)
                                    .cornerRadius(9)
                                    .foregroundColor(Color.white)
                            } //: save button

                        } //: vstack
                        .scrollDismissesKeyboard(.immediately)
                        .padding(.horizontal)
                        .padding(.vertical, 30)
                    } //: vstack
                    .navigationTitle("New Task")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        // sheet close button
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                            }
                        } //: sheet close button
                        
                        
                        // keyboard close button
                        ToolbarItemGroup(placement: .keyboard) {
                            Button {
                                self.focus = false
                            } label: {
                                Text("Close")
                            }
                            
                            Spacer()
                            
                            Button {
                                self.focus = false
                            } label: {
                                Text("Close")
                            }
                        } //: keyboard close button
                    }
                    .alert(Text(errorTitle), isPresented: $errorShowing) {
                        
                    }
                } //: Geometry
            } //: zstack
            
        } //: navigation
        .tint(themes[self.theme.themeSettings].themeColor)
    }
}

// MARK: - preview
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
    }
}
