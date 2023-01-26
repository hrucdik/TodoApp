//
//  ContentView.swift
//  Todo App
//
//  Created by horiuchi on 2023/01/17.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    // MARK: - properties
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Todo.entity(),
        sortDescriptors:[
            NSSortDescriptor(keyPath: \Todo.time, ascending: true),
            NSSortDescriptor(keyPath: \Todo.objectID, ascending: true)
        ],
        animation: .default)
    
    private var todos: FetchedResults<Todo>
    
    @State private var showingAddTodoView: Bool = false
    @State private var animatingButton: Bool = false
    @State private var showingSettingsView: Bool = false
    
    
    
    // MARK: - theme
    
    @ObservedObject var theme = ThemeSettings.shared
    var themes: [Theme] = themeData
    
    // MARK: - function
    
    private func deleteTodo(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let todo = todos[index]
                viewContext.delete(todo)
                
                do {
                    try viewContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func colorize(priority: String) -> Color {
        switch priority {
        case "高い":
            return Color("redColor")
        case "普通":
            return Color("greenColor")
        case "低い":
            return Color("blueColor")
        default:
            return .gray
        }
    }
    
    // MARK: - body
    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea(.all)
                List {
                    ForEach(todos, id: \.self) { todo in
                        HStack {
                            
                            //MARK: - time && priority == ""
                            
                            if todo.time == "" && todo.priority == "" {
                                HStack {
                                    Circle()
                                        .frame(width: 12, height: 12, alignment: .center)
                                        .foregroundColor(self.colorize(priority: todo.priority ?? "普通"))
                                        .padding(.bottom, 8)
                                    
                                    
                                    Text(todo.name ?? "Unknown")
                                        .font(.system(size: 17, weight: .bold, design: .rounded))
                                        .padding(.bottom, 8)
                                } //: hstack
                                .padding(.top, 7)
                                
                                //: time && priority == ""
                                
                            } else if todo.time == "" && todo.priority != "" {
                                
                                // MARK: - time == "" && priority != ""
                                
                                HStack {
                                    Circle()
                                        .frame(width: 12, height: 12, alignment: .center)
                                        .foregroundColor(self.colorize(priority: todo.priority ?? "普通"))
                                        .padding(.vertical, 12)
                                    
                                    
                                    
                                    Text(todo.name ?? "Unknown")
                                        .font(.system(size: 17, weight: .bold, design: .rounded))
                                    
                                    
                                    Spacer()
                                    
                                    Text(todo.priority ?? "Unknown")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Color(UIColor.systemGray2))
                                        .padding(3)
                                        .frame(minWidth: 42)
                                        .overlay(
                                            Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.8)
                                        )
                                } //: hstack
                                //: time == "" && priority != ""
                                
                            } else if todo.time != "" && todo.priority == "" {
                                
                                // MARK: - time != "" && priority == ""
                                
                                Circle()
                                    .frame(width: 12, height: 12, alignment: .center)
                                    .foregroundColor(self.colorize(priority: todo.priority ?? "普通"))
                                    .padding(.bottom, 25)
                                
                                
                                VStack(alignment: .leading, spacing: 9) {
                                    Text(todo.name ?? "Unknown")
                                        .font(.system(size: 17, weight: .bold, design: .rounded))
                                    
                                    
                                    
                                    HStack(alignment: .center, spacing: 2) {
                                        
                                            Image(systemName: "clock")
                                                .resizable()
                                                .frame(width: 12, height: 12)
                                            
                                            Text(todo.time ?? "\(Date.now)")
                                                .font(.system(size: 13))
                                        
                                    } //: hstack
                                    .foregroundColor(.brown)
                                    .fontWeight(.semibold)
                                } //: vstack
                                //: time != "" && priority == ""
                                
                            } else {
                                
                                // MARK: - time && priority != ""
                                
                                Circle()
                                    .frame(width: 12, height: 12, alignment: .center)
                                    .foregroundColor(self.colorize(priority: todo.priority ?? "普通"))
                                    .padding(.bottom, 25)
                                
                                
                                VStack(alignment: .leading, spacing: 9) {
                                    Text(todo.name ?? "Unknown")
                                        .font(.system(size: 17, weight: .bold, design: .rounded))
                                    
                                    HStack(alignment: .center, spacing: 2) {
                                        
                                            Image(systemName: "clock")
                                                .resizable()
                                                .frame(width: 12, height: 12)
                                            
                                            Text(todo.time ?? "\(Date.now)")
                                                .font(.system(size: 13))
                                        
                                    } //: hstack
                                    .foregroundColor(.brown)
                                    .fontWeight(.semibold)
                                } //: vstack
                            
                                Spacer()
                                
                                    Text(todo.priority ?? "Unknown")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Color(UIColor.systemGray2))
                                        .padding(3)
                                        .frame(minWidth: 42)
                                        .overlay(
                                            Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.8)
                                        )
                                
                            } //: time && priority != ""
                        } //: hstack
                        .padding(.vertical, 4)
                    } //: foreach
                    .onDelete(perform: deleteTodo)
                } //: list
                .scrollContentBackground(.hidden)
                .navigationTitle("Todo")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    // MARK: - edit button
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                            .tint(themes[self.theme.themeSettings].themeColor)
                    } //: edit button
                    
                    // MARK: - add todo view
                    ToolbarItem {
                        Button {
                            self.showingSettingsView.toggle()
                        } label: {
                            Image(systemName: "paintbrush")
                                .imageScale(.large)
                        }
                        .tint(themes[self.theme.themeSettings].themeColor)
                        .sheet(isPresented: $showingSettingsView) {
                            SettingsView()
                        }
                    }//: settings button
                } //: toolbar
                
                
                // MARK: - No todo items
                if todos.count == 0 {
                    EmptyListView()
                }
                
            } //: zstack
            .sheet(isPresented: $showingAddTodoView) {
                AddTodoView().environment(\.managedObjectContext, viewContext)
            }
            
            .overlay(
                ZStack {
                    Group {
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.animatingButton ? 0.2 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0.1)
                            .frame(width: 68, height: 68, alignment: .center)
                        Circle()
                            .fill(themes[self.theme.themeSettings].themeColor)
                            .opacity(self.animatingButton ? 0.15 : 0)
                            .scaleEffect(self.animatingButton ? 1 : 0.1)
                            .frame(width: 88, height: 88, alignment: .center)
                    }
                    .animation(.easeOut(duration: 2).repeatForever(autoreverses: true), value: animatingButton)
                    
                    Button(action: {
                        self.showingAddTodoView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .background(Circle().fill(Color("ColorBase")))
                            .frame(width: 48, height: 48, alignment: .center)
                    }) //: button
                    .tint(themes[self.theme.themeSettings].themeColor)
                    .onAppear() {
                        self.animatingButton.toggle()
                    }
                } //: zstack
                    .tint(themes[self.theme.themeSettings].themeColor)
                    .padding(.bottom, 15)
                    .padding(.trailing, 17)
                , alignment: .bottomTrailing
            ) //: overlay
        } //: navigation
    }
}


// MARK: - preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
