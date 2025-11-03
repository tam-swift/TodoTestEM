//
//  NewTodoView.swift
//  TestEM
//
//  Created by Tamerlan Swift on 28.10.2025.
//

import SwiftUI

struct NewTodoView: View {
    
    @EnvironmentObject private var vm: TodosViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let todoId: Int?
    @State private var title: String = ""
    @State private var description: String = ""

    init(todoId: Int? = nil) {
        self.todoId = todoId
    }
    
    @State private var currentTodo: Todo?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("Заголовок", text: $title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(currentTodo?.addDate.dateFormatter() ?? Date().dateFormatter())
                .font(.subheadline)
                .foregroundStyle(.gray)
            
            TextEditor(text: $description)
                .font(.system(size: 19, weight: .regular))
                .tracking(-0.43)
                .lineSpacing(6)
                .frame(minHeight: 150)
                .overlay(alignment: .topLeading) {
                    if description.isEmpty {
                        Text("Описание")
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                            .padding(.leading, 5)
                            .font(.system(size: 19, weight: .regular))
                            .allowsHitTesting(false)
                    }
                }
            Spacer()
        }
        .padding()
        
        .onAppear{ getTodoField() }
        
        // Toolbar
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { backButton }
            ToolbarItem(placement: .topBarTrailing) { saveButton }
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    private var backButton: some View {
        HStack {
            Image(systemName: "chevron.left")
                .fontWeight(.semibold)
            Text("Назад")
                .font(.title3)
        }
        .onTapGesture {
            dismiss()
        }
        .foregroundStyle(.myYellow)
        .padding(.leading, -12)
    }
    
    private var saveButton: some View {
        Button(action: {
            withAnimation(.spring()) {
                if let todo = currentTodo {
                    vm.updateTodo(todo,
                                  title: title,
                                description: description)
                } else {
                    vm.addTodo(todo: title,
                               description: description)
                }
            }
            dismiss()
        }) {
            Text(currentTodo != nil ? "Сохранить" : "Добавить")
                .font(.title3)
                .foregroundStyle(.myYellow)
                .padding(.trailing, 12)
                .opacity(saveButtonDisabled() ? 0.3 : 1)
        }
        .disabled(saveButtonDisabled())
    }
    
    private func saveButtonDisabled() -> Bool {
        guard let todo = currentTodo else {
            return title.isEmpty 
        }
        return (title == todo.todo && description == todo.description ?? "") || title.isEmpty
    }
    
    private func getTodoField() {
        if let todoId = todoId
        {
            currentTodo = vm.getTodo(by: todoId)
            title = currentTodo?.todo ?? ""
            description = currentTodo?.description ?? ""
        }
    }
}


#Preview {
    NavigationStack {
        NewTodoView(todoId: 0)
             .environmentObject(TodosViewModel()) 
    }
}


