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
        NavigationStack {
            ZStack {
                // Background gradient moderne
                LinearGradient(
                    colors: [Color(.systemGroupedBackground), Color(.systemBackground)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                self.content
            }
            .navigationTitle("Islands")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showingSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background {
                                Circle()
                                    .fill(.blue.gradient)
                                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                        .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $viewModel.showingSheet, onDismiss: reloadIslandsList) {
                IslandDetailsView(island: DBModel.Island())
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
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.2)
            
            Text("Loading islands...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
    
    func failedView(_ error: Error) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Something went wrong")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                loadIslandsList(forceReload: true)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

//MARK: - Displaying Content

@MainActor
private extension IslandsListView {
    @ViewBuilder
    func loadedView() -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if islands.isEmpty && !searchText.isEmpty {
                    emptySearchView()
                } else if islands.isEmpty {
                    emptyStateView()
                } else {
                    List {
                        ForEach(islands) { island in
                            NavigationLink {
                                IslandDetailsView(island: island)
                            } label: {
                                IslandCell(island: island)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .onAppear {
            loadIslandsList(forceReload: true)
        }
        .searchable(text: $searchText, prompt: "Search islands...")
        .refreshable {
            loadIslandsList(forceReload: true)
        }
    }
    
    @ViewBuilder
    func emptySearchView() -> some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No islands found")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Try searching with different keywords")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 60)
    }
    
    @ViewBuilder
    func emptyStateView() -> some View {
        VStack(spacing: 24) {
            Image(systemName: "map")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            VStack(spacing: 8) {
                Text("No Islands Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Create your first island to get started with Anno 1800 calculations")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Create Island") {
                viewModel.showingSheet.toggle()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(32)
        .padding(.top, 60)
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
    
    private func delete(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let island = self.islands[index]
                try await injected.interactors.islands.delete(island: island)
            }
        }
    }
}

#Preview {
    IslandsListView()
}
