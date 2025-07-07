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
    @State private var selectedIsland: DBModel.Island?
    @State private var islands: [DBModel.Island] = []
    @State private(set) var islandsState: Loadable<Void>
    @State internal var searchText = ""
    @Environment(\.injected) private var injected: DIContainer
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    
    init(state: Loadable<Void> = .notRequested) {
        self._islandsState = .init(initialValue: state)
    }
    
    var body: some View {
        //navigationView
        content
            .onAppear {
                loadIslandsList(forceReload: false)
            }
            .blur(radius: viewModel.showingSheet ? 3 : 0) // flou appliqué dynamiquement
            .animation(.easeInOut(duration: 0.3), value: viewModel.showingSheet)
            .sheet(isPresented: $viewModel.showingSheet, onDismiss: reloadIslandsList) {
                IslandDetailsView(island: DBModel.Island())
            }
        //        NavigationStack {
        //            ZStack {
        //                // Background gradient moderne
        //                LinearGradient(
        //                    colors: [Color(.systemGroupedBackground), Color(.systemBackground)],
        //                    startPoint: .topLeading,
        //                    endPoint: .bottomTrailing
        //                )
        //                .ignoresSafeArea()
        //
        //                self.content
        //            }
        //            .navigationTitle("Islands")
        //            .navigationBarTitleDisplayMode(.large)
        //            .toolbar {
        //                ToolbarItem(placement: .topBarTrailing) {
        //                    Button {
        //                        viewModel.showingSheet.toggle()
        //                    } label: {
        //                        Image(systemName: "plus")
        //                            .font(.title2)
        //                            .fontWeight(.semibold)
        //                            .foregroundColor(.white)
        //                            .frame(width: 36, height: 36)
        //                            .background {
        //                                Circle()
        //                                    .fill(.blue.gradient)
        //                                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
        //                            }
        //                    }
        //                }
        //
        //                ToolbarItem(placement: .topBarLeading) {
        //                    EditButton()
        //                        .fontWeight(.semibold)
        //                }
        //            }
        //            .sheet(isPresented: $viewModel.showingSheet, onDismiss: reloadIslandsList) {
        //                IslandDetailsView(island: DBModel.Island())
        //            }
        //        }
        //        .onAppear {
        //            loadIslandsList(forceReload: false)
        //        }
    }
    
    @ViewBuilder private var content: some View {
        switch islandsState {
        case .notRequested:
            defaultView()
        case .isLoading:
            loadingView()
        case .loaded:
            //loadedView()
            loadedNavigationSplitView()
        case .failed(let error):
            failedView(error)
        }
    }
}

private extension IslandsListView {
    private var navigationView: some View {
        ZStack {
            // Background gradient moderne
            LinearGradient(
                colors: [Color(.systemGroupedBackground), Color(.systemBackground)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            NavigationSplitView(columnVisibility: $columnVisibility) {
                masterView
            } detail: {
                detailView
            }
            .navigationSplitViewStyle(.balanced)
        }
    }
}

private extension IslandsListView {
    private var masterView: some View {
        List(selection: $selectedIsland) {
            ForEach(filteredIslands) { island in
                NavigationLink(value: island) {
                    IslandCell(island: island)
                }
            }
            .onDelete(perform: delete)
        }
        .listStyle(.sidebar)
        .searchable(text: $searchText, prompt: "Search islands...")
        .toolbar {
            // Groupe les boutons à droite
            ToolbarItemGroup(placement: .topBarTrailing) {
                // Menu de sélection de langue
                Menu {
                    // Section pour basculer entre système et personnalisé
                    Button(action: {
                        AppLanguageManager.shared.resetToSystemLanguage()
                    }) {
                        HStack {
                            Text("System Language")
                            if !AppLanguageManager.shared.isUsingCustomLanguage {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Liste des langues disponibles
                    ForEach(Language.availableLanguages) { language in
                        Button(action: {
                            AppLanguageManager.shared.currentLanguage = language.id
                        }) {
                            HStack {
                                Text(language.nativeName)
                                if AppLanguageManager.shared.currentLanguage == language.id && AppLanguageManager.shared.isUsingCustomLanguage {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "globe")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                
                // Bouton d'ajout existant
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
        // Observer les changements de langue pour recharger les données
        .onLanguageChange {
            loadIslandsList(forceReload: true)
        }
    }
}

private extension IslandsListView {
    private var detailView: some View {
        Group {
            if let island = selectedIsland {
                IslandDetailsView(island: island)
                    .id(UUID())
            } else {
                VStack(spacing: 24) {
                    Image(systemName: "map")
                        .font(.system(size: 64))
                        .foregroundColor(.blue)
                    Text("Select an island to see the details...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

//MARK: - Loading Content

private extension IslandsListView {
    func defaultView() -> some View {
        Text("").onAppear() {
            if !islands.isEmpty {
                islandsState = .loaded(())
            } else {
                loadIslandsList(forceReload: false)
            }
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
    func loadedNavigationSplitView() -> some View {
        if islands.isEmpty && !searchText.isEmpty {
            emptySearchView()
        } else if islands.isEmpty {
            emptyStateView()
        } else {
            // Utiliser List directement sans ScrollView/LazyVStack
            navigationView
                .searchable(text: $searchText, prompt: "Search islands...")
                .refreshable {
                    loadIslandsList(forceReload: true)
                }
        }
    }
}

@MainActor
private extension IslandsListView {
    @ViewBuilder
    func loadedView() -> some View {
        if islands.isEmpty && !searchText.isEmpty {
            emptySearchView()
        } else if islands.isEmpty {
            emptyStateView()
        } else {
            // Utiliser List directement sans ScrollView/LazyVStack
            List {
                ForEach(filteredIslands) { island in
                    NavigationLink {
                        IslandDetailsView(island: island)
                    } label: {
                        IslandCell(island: island)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .onDelete(perform: delete)
            }
            .listStyle(PlainListStyle())
            .searchable(text: $searchText, prompt: "Search islands...")
            .refreshable {
                loadIslandsList(forceReload: true)
            }
        }
    }
    
    // Computed property pour filtrer les îles
    var filteredIslands: [DBModel.Island] {
        if searchText.isEmpty {
            return islands
        } else {
            return islands.filter { island in
                // Adaptez cette logique selon les propriétés de votre modèle Island
                island.name.localizedCaseInsensitiveContains(searchText)
            }
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
            do {
                let loadedIslands = try await injected.interactors.islands.fetchIslandsList()
                await MainActor.run {
                    self.islands = loadedIslands
                    self.islandsState = .loaded(())
                }
            } catch {
                await MainActor.run {
                    self.islandsState = .failed(error)
                }
            }
        }
    }
    
    private func reloadIslandsList() {
        loadIslandsList(forceReload: true)
    }
    
    private func delete(at offsets: IndexSet) {
        Task {
            do {
                for index in offsets {
                    let island = self.islands[index]
                    try await injected.interactors.islands.delete(island: island)
                }
                await MainActor.run {
                    self.islands.remove(atOffsets: offsets)
                }
            } catch {
                // Gérer l'erreur de suppression
                print("Error deleting island: \(error)")
            }
        }
    }
}

#Preview {
    IslandsListView()
}
