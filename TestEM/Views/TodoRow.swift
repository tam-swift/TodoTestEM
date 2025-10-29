//
//  TodoRow.swift
//  TestEM
//
//  Created by Tamerlan Swift on 26.10.2025.
//

import SwiftUI

struct TodoRow: View {
    
    @Environment(\.colorScheme) var colorSheme
    
    @EnvironmentObject var vm: TodosViewModel
    
    @State private var isLongPressing = false
    @Binding var selectedTodo: Todo?
    
    let todo: Todo
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 17) {
            Image(systemName: todo.completed ? "checkmark.circle" :"circle")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(todo.completed ? .myYellow : .gray)
                .fontWeight(.light)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 5) {
                Text(todo.todo)
                    .strikethrough(todo.completed)
                    .font(.title3)
                    .fontWeight(.medium)
                Text(todo.description ?? "Описание пусто")
                    .font(.subheadline)
                Text(todo.addDate.dateFormatter())
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.background.opacity(0.0001))
            
        )
        .onTapGesture {
            withAnimation(.spring()) {
                vm.switchCompleted(todo: todo)
            }
        }
        .foregroundStyle(todo.completed ? .gray : .accent )
        .contextMenu {
            
            NavigationLink {
                NewTodoView(todoId: todo.id)
                    .environmentObject(vm)
            } label: {
                Label("Редактировать",systemImage: "square.and.pencil")
            }

            Button(action :{
                
            }) {
                Label("Поделиться", systemImage: "square.and.arrow.up")
            }
            Button(role: .destructive ,action :{
                withAnimation(.spring) {
                    vm.deleteTodo(todo: todo)
                }
            }) {
                Label("Удалить", systemImage: "trash")
            }
        }
        
    }
}
#Preview {
    NavigationStack {
        List {
            TodoRow(selectedTodo: .constant(PreviewSupport.instance.todos[1]), todo: PreviewSupport.instance.todos[1])
                .environmentObject(TodosViewModel())
        }
        .listStyle(.plain)
    }
}

struct Aboba : View {
    var body: some View {
        Text("Привед")
    }
    
}
