//
//  IslandsListView.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 30/05/2025.
//

import SwiftUI

struct IslandsListView: View {
    @State private(set) var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                self.content
                    .navigationTitle("Islands")
                    .toolbar {
                        ToolbarItem(id: "add", placement: .topBarTrailing) {
                            Button("Ajouter", systemImage: "plus.square") {
                                viewModel.showingSheet.toggle()
                            }
                        }
                        ToolbarItem(id: "edit", placement: .topBarLeading) {
                            EditButton()
                        }
                    }
                    .sheet(isPresented: $viewModel.showingSheet) {
                        IslandDetailsView(viewModel: .init(island: Island()))
                    }
            }
        }
    }
    
    @ViewBuilder private var content: some View {
        loadedView(viewModel.islands, showSearch: true, showLoading: false)
    }
    
    
}

//MARK: - Displaying Content

private extension IslandsListView {
    func loadedView(_ islands: [Island], showSearch: Bool, showLoading: Bool) -> some View {
        VStack {
            if showSearch {
                
            }
            
            if showLoading {
                ProgressView()
                    .padding()
            }
            
            List(islands) { island in
                NavigationLink(
                    destination: self.detailsView(island: island)
                ) {
                    IslandCell(island: island)
                }
            }
            .id(UUID())
            
        }
    }
    
    func detailsView(island: Island) -> some View {
        IslandDetailsView(viewModel: .init(island: island))
    }
}

#Preview {
    IslandsListView(viewModel: .example)
}
