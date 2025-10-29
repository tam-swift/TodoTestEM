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
    
    let todoId: Int?
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
                            .padding(.top, 8)
                            .allowsHitTesting(false)
                    }
                }
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
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
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    withAnimation(.spring()) {
                        if let todo = currentTodo {
                            vm.saveTodo(todo: todo,
                                        name: title,
                                        description: description)
                        } else {
                            vm.addTodo(name: title,
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
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if let todoId = todoId
            {
                currentTodo = vm.getTodo(by: todoId)
                title = currentTodo?.todo ?? ""
                description = currentTodo?.description ?? ""
            }

        }
    }
        
    
    private func saveButtonDisabled() -> Bool {
        guard let todo = currentTodo else {
            return title.isEmpty || description.isEmpty
        }
        return (title == todo.todo && description == todo.description ?? "") || title.isEmpty
    }
}


#Preview {
    NavigationStack {
        NewTodoView(todoId: 0)
             .environmentObject(TodosViewModel()) // ⭐️ Явно передаем
    }
}


