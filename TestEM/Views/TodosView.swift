//
//  TodosView.swift
//  TestEM
//
//  Created by Tamerlan Swift on 26.10.2025.
//

import SwiftUI

struct TodosView: View {
    
    @EnvironmentObject private var vm: TodosViewModel

    var body: some View {
        
        VStack(spacing: 0) {
            SearchBarView(searchText: $vm.searchText)
                .padding(.horizontal, 10)
            List {
                todoList
                    .padding(.vertical, -2)
            }
            .listStyle(.plain)
            .scrollDismissesKeyboard(.immediately)
        }
       
        // Toolbar
        .navigationTitle("Задачи")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Text(vm.todos.isEmpty ? "Задач нет" : "\(vm.todos.count) Задач")
                    .font(.subheadline)
                Spacer()
                NavigationLink {
                    NewTodoView()
                        .environmentObject(vm)
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 27, height: 27)
                        .foregroundStyle(Color.myYellow)
                        .padding()
                }
            }
        }
        .toolbarBackground(.visible, for: .bottomBar)
        .toolbarBackground(Color.myGray, for: .bottomBar)

    }
}

#Preview {
    NavigationStack {
        TodosView()
            .environmentObject(TodosViewModel())
    }
}

extension TodosView {
    private var todoList: some View {
        ForEach(vm.todos) { todo in
            TodoRow(todo: todo)
                .listRowSeparatorTint(.gray)
        }
        
    }
}
