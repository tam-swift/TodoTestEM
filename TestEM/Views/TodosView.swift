//
//  TodosView.swift
//  TestEM
//
//  Created by Tamerlan Swift on 26.10.2025.
//

import SwiftUI

struct TodosView: View {
    
    @EnvironmentObject private var vm: TodosViewModel
    @State private var selectedTodo: Todo?

    var body: some View {
        
        List {
            Section {
                todoList
            } header: {
                VStack {
                    SearchBarView(searchText: $vm.searchText)
                    
                }
                
            }
        }
        .padding(.horizontal, -8)
        .listStyle(.plain)
        .navigationTitle("Задачи")
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
            TodoRow(selectedTodo: $selectedTodo, todo: todo)
        }
        
    }
}
