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
    
    let todo: Todo
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 17) {
            checkmarkImage
            todoInfoVStack
        }
        .foregroundStyle(todo.completed ? .gray : .accent )
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.background.opacity(0.0001))
            
        )
        .onTapGesture {
            withAnimation(.spring()) {
                vm.toggleCompleted(todo)
            }
        }
        
        .contextMenu{ contextMenuButtons }
    }
}
#Preview {
    NavigationStack {
        List {
            TodoRow(todo: PreviewSupport.instance.todos[1])
                .environmentObject(TodosViewModel())
        }
        .listStyle(.plain)
    }
}

extension TodoRow {
    
    private var contextMenuButtons: some View {
        Group {
            NavigationLink {
                NewTodoView(todoId: todo.id)
                    .environmentObject(vm)
            } label: {
                Label("Редактировать",systemImage: "square.and.pencil")
            }
            ShareLink(item: "\(todo.todo)\n\n\(todo.description ?? "")") {
            Label("Поделиться", systemImage: "square.and.arrow.up")
            }
            Button(role: .destructive ,action :{
                withAnimation(.spring) {
                    vm.deleteTodo(todo)
                }
            }) {
                Label("Удалить", systemImage: "trash")
            }
        }
    }
    
    private var checkmarkImage: some View {
        Image(systemName: todo.completed ? "checkmark.circle" :"circle")
            .resizable()
            .frame(width: 25, height: 25)
            .foregroundStyle(todo.completed ? .myYellow : .gray)
            .fontWeight(.light)
            .padding(.top, 2)
    }
    
    private var todoInfoVStack: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(todo.todo)
                .strikethrough(todo.completed)
                .font(.title3)
                .fontWeight(.medium)
                .lineLimit(1)
            Text(todo.description ?? "Описание пусто")
                .font(.subheadline)
                .lineLimit(2)
            Text(todo.addDate.dateFormatter())
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
    }
}
