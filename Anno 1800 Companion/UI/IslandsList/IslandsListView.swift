//
//  IslandsListView.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 30/05/2025.
//

import SwiftData
import SwiftUI

struct IslandsListView: View {
    @State private(set) var viewModel: ViewModel = ViewModel()
    @State private var islands: [DBModel.Island] = []
    @State private(set) var islandsState: Loadable<Void>
    @State internal var searchText = ""
    @Environment(\.injected) private var injected: DIContainer
    
    init(state: Loadable<Void> = .notRequested) {
        self._islandsState = .init(initialValue: state)
    }
    
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
                        ToolbarItem(id: "refresh", placement: .bottomBar) {
                            Button("Refresh", systemImage: "arrow.clockwise") {
                                loadIslandsList(forceReload: true)
                            }
                        }
                    }
                    .sheet(isPresented: $viewModel.showingSheet, onDismiss: reloadIslandsList) {
                        NewIslandView(viewModel: .init(island: .init()))
                    }
            }
        }
    }
    
    @ViewBuilder private var content: some View {
        loadedView()
    }
}

//MARK: - Loading Content

private extension IslandsListView {
    func defaultView() -> some View {
        Text("").onAppear() {
            if !islands.isEmpty {
                islandsState = .loaded(())
            }
            loadIslandsList(forceReload: false)
        }
    }
    
    func loadingView() -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            loadIslandsList(forceReload: true)
        })
    }
}

//MARK: - Displaying Content

@MainActor
private extension IslandsListView {
    @ViewBuilder
    func loadedView() -> some View {
        if islands.isEmpty && !searchText.isEmpty {
            Text("No match found")
                .font(.footnote)
        }
        List(islands) { island in
            NavigationLink {
                IslandDetailsView(island: island)
            } label: {
                IslandCell(island: island)
            }
        }
        .onAppear {
            loadIslandsList(forceReload: true)
        }
        .searchable(text: $searchText)
        .refreshable {
            loadIslandsList(forceReload: true)
        }
    }
}

private extension IslandsListView {
    private func loadIslandsList(forceReload: Bool) {
        guard forceReload || islands.isEmpty else { return }
        Task {
            self.islands = try await injected.interactors.islands.fetchIslandsList()
        }
    }
    
    private func reloadIslandsList() {
        loadIslandsList(forceReload: true)
    }
}

#Preview {
    //IslandsListView(viewModel: .example)
}
