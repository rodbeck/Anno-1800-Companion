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
                    }
                    .onAppear {
                        loadIslandsList(forceReload: true)
                    }
                    .sheet(isPresented: $viewModel.showingSheet) {
                        IslandDetailsView(viewModel: .init(island: .init()))
                    }
            }
        }
    }
    
    @ViewBuilder private var content: some View {
        switch islandsState {
        case .notRequested:
            defaultView()
        case .isLoading:
            loadingView()
        case .loaded:
            loadedView()
        case let .failed(error):
            failedView(error)
        }
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
        List(selection: $viewModel.selectedIslandId) {
            ForEach(RegionEnum.allCases, id:\.self) { region in
                let islandsForRegions = islands.filter { $0.region == region }
                if !islandsForRegions.isEmpty {
                    Section(header: Text(region.description.capitalized)) {
                        ForEach(islandsForRegions) { island in
                            NavigationLink(destination: self.detailsView(island: island)) {
                                IslandCell(island: island)
                            }
                        }
                    }
                }
            }
        }
        .refreshable {
            loadIslandsList(forceReload: true)
        }
        .searchable(text: $searchText)
        .id(UUID())
    }
    
    func detailsView(island: DBModel.Island) -> some View {
        IslandDetailsView(viewModel: .init(island: .init(
            name: island.name,
            region: island.region.id,
            farmers: island.farmers,
            workers: island.workers,
            artisans: island.artisans,
            engineers: island.engineers,
            investors: island.investors,
            jornaleros: island.jornaleros,
            obreros: island.obreros,
            explorers: island.explorers,
            technicians: island.technicians,
            sheperds: island.sheperds,
            elders: island.elders
        )))
    }
}

private extension IslandsListView {
    private func loadIslandsList(forceReload: Bool) {
        guard forceReload || islands.isEmpty else { return }
        Task {
            self.islands = try await injected.interactors.islands.fetchIslandsList()
        }
    }
}

#Preview {
    //IslandsListView(viewModel: .example)
}
