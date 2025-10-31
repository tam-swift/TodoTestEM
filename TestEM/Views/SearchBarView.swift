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
                .padding(.leading, 45)
                .font(.system(size: 18))
                .overlay(alignment: .topLeading) {
                    if searchText.isEmpty {
                        Text("Search")
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                            .padding(.leading, 45)
                            .allowsHitTesting(false)
                    }
                }
                .overlay(
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .padding(.leading, 13)
                        .foregroundStyle(.gray)
                    , alignment: .leading
                )
            
                .overlay(
                    Image(systemName: "microphone.fill")
                        .font(.system(size: 20))
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
