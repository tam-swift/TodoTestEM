//
//  SearchBarView.swift
//  TestEM
//
//  Created by Tamerlan Swift on 26.10.2025.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 45)
                .foregroundStyle(.myGray)
            TextField("", text: $searchText)
                .placeholder(when: searchText.isEmpty) {
                    Text("Search")
                        .foregroundStyle(.gray)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 40)
                .overlay(
                    Image(systemName: "magnifyingglass")
                        .font(.headline)
                        .padding(.leading, 13)
                        .foregroundStyle(.gray)
                    , alignment: .leading
                )
            
                .overlay(
                    Image(systemName: "microphone.fill")
                        .font(.headline)
                        .padding(.trailing)
                        .foregroundStyle(.gray)

                    ,alignment: .trailing
                )
        }
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
        .padding(.horizontal)
}
