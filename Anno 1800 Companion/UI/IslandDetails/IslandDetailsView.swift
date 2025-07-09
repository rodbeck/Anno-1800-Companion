//
//  IslandDetailsView.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 06/07/2025.
//

import SwiftData
import SwiftUI

struct IslandDetailsView: View {
    @Environment(\.injected) private var injected: DIContainer
    @Environment(\.dismiss) var dismiss
    @State private var edit = false
    @State private(set) var viewModel: ViewModel
    @State private var showingDeleteAlert = false
    @State private var selectedLanguage = AppLanguageManager.shared.currentLanguage
    @State private var isUsingCustomLanguage = AppLanguageManager.shared.isUsingCustomLanguage
    
    init(island: DBModel.Island) {
        viewModel = .init(island: island)
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
                
                ScrollView {
                    VStack(spacing: 24) {
                        globalSection()
                        populationSection()
                        calculationSection()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle(L("Island Details"))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    // Menu de sélection de langue
                    Menu {
                        // Section pour basculer entre système et personnalisé
                        Button(action: {
                            AppLanguageManager.shared.resetToSystemLanguage()
                        }) {
                            HStack {
                                Text(L("System Language"))
                                if !AppLanguageManager.shared.isUsingCustomLanguage {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        
                        Divider()
                        
                        // Liste des langues disponibles
                        ForEach(Language.availableLanguages) { language in
                            Button(action: {
                                AppLanguageManager.shared.currentLanguage = language.id
                                // Mise à jour immédiate de l'état local
                                selectedLanguage = language.id
                                isUsingCustomLanguage = AppLanguageManager.shared.isUsingCustomLanguage
                            }) {
                                HStack {
                                    Text(language.nativeName)
                                    Spacer()
                                    if AppLanguageManager.shared.isUsingCustomLanguage &&
                                        AppLanguageManager.shared.currentLanguage == language.id {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
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
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(L("Calculate"), systemImage: "function") {
                            viewModel.calculate()
                        }
                        .disabled(!viewModel.isCalculateEnabled)
                        
                        Button(L("Save"), systemImage: "square.and.arrow.down") {
                            Task {
                                await save()
                            }
                        }
                        .disabled(!viewModel.isSaveEnabled)
                        
                        Divider()
                        
                        Button(L("Delete"), systemImage: "trash", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                if UIDevice.current.userInterfaceIdiom == .pad {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(L("Done")) {
                            dismiss()
                        }
                        .fontWeight(.semibold)
                    }
                }
            }
            .alert(L("Delete Island"), isPresented: $showingDeleteAlert) {
                Button(L("Cancel"), role: .cancel) {}
                Button(L("Delete"), role: .destructive) {
                    Task {
                        await delete()
                    }
                }
            } message: {
                Text(L("Are you sure you want to delete this island? This action cannot be undone."))
            }
        }
        .onLanguageChange {
            selectedLanguage = AppLanguageManager.shared.currentLanguage
            isUsingCustomLanguage = AppLanguageManager.shared.isUsingCustomLanguage
            viewModel.reload()
        }
        .onAppear {
            selectedLanguage = AppLanguageManager.shared.currentLanguage
            isUsingCustomLanguage = AppLanguageManager.shared.isUsingCustomLanguage
            viewModel.calculate()
        }
    }
}

// MARK: - Global Section

private extension IslandDetailsView {
    @ViewBuilder
    func globalSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("General Information"))
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                // Island name
                VStack(alignment: .leading, spacing: 8) {
                    Text(L("Island Name"))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    TextField(L("Enter island name"), text: $viewModel.island.name)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                }
                
                // Region selector
                VStack(alignment: .leading, spacing: 8) {
                    Text(L("Region"))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Menu {
                        ForEach(RegionEnum.allCases, id: \.self) { region in
                            Button {
                                viewModel.island.region = region
                            } label: {
                                HStack {
                                    Image(region.img)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                    Text(viewModel.regions.entries[region.keyString]?.name ?? "?")
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(viewModel.island.region.img)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                            
                            Text(viewModel.regionName)
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.regularMaterial)
                                .stroke(.quaternary, lineWidth: 1)
                        }
                    }
                }
                
                // Action buttons
                HStack(spacing: 12) {
                    Button(L("Calculate")) {
                        viewModel.calculate()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(!viewModel.isCalculateEnabled)
                    
                    Button(L("Save Changes")) {
                        Task {
                            await save()
                            dismiss()
                        }
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .disabled(!viewModel.isSaveEnabled)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
            }
        }
    }
}

// MARK: - Population Display

private extension IslandDetailsView {
    @ViewBuilder
    func populationSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            switch viewModel.island.region.keyString {
            case "oldWorld":
                populationCard(title: viewModel.regions.entries["oldWorld"]?.name ?? "?", workers: [
                    ("farmers", "icons/workforce-farmers", $viewModel.island.farmers),
                    ("workers", "icons/workforce-workers", $viewModel.island.workers),
                    ("artisans", "icons/workforce-artisans", $viewModel.island.artisans),
                    ("engineers", "icons/workforce-engineers", $viewModel.island.engineers),
                    ("investors", "icons/icon-credits", $viewModel.island.investors)
                ])
            case "newWorld":
                populationCard(title: viewModel.regions.entries["newWorld"]?.name ?? "?", workers: [
                    ("jornaleros", "icons/workforce-jornaleros", $viewModel.island.jornaleros),
                    ("obreros", "icons/workforce-obreros", $viewModel.island.obreros)
                ])
            case "capeTrelawney":
                populationCard(title: viewModel.regions.entries["capeTrelawney"]?.name ?? "?", workers: [
                    ("farmers", "icons/workforce-farmers", $viewModel.island.farmers),
                    ("workers", "icons/workforce-workers", $viewModel.island.workers),
                    ("artisans", "icons/workforce-artisans", $viewModel.island.artisans),
                    ("engineers", "icons/workforce-engineers", $viewModel.island.engineers),
                    ("investors", "icons/icon-credits", $viewModel.island.investors)
                ])
            case "theArctic":
                populationCard(title: viewModel.regions.entries["theArctic"]?.name ?? "?", workers: [
                    ("explorers", "icons/workforce-explorers", $viewModel.island.explorers),
                    ("technicians", "icons/workforce-technicians", $viewModel.island.technicians)
                ])
            case "enbesa":
                populationCard(title: viewModel.regions.entries["enbesa"]?.name ?? "?", workers: [
                    ("shepherds", "icons/workforce-shepherds", $viewModel.island.sheperds),
                    ("elders", "icons/workforce-elders", $viewModel.island.elders)
                ])
            default:
                ContentUnavailableView("Unknown region", systemImage: "questionmark.circle")
            }
        }
    }
    
    @ViewBuilder
    func populationCard(title: String, workers: [(String, String, Binding<Int>)]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 1), spacing: 12) {
                ForEach(workers, id: \.0) { worker in
                    workerCard(
                        workerName: worker.0,
                        rightImageId: worker.1,
                        count: worker.2
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
        }
    }
    
    func workerCard(workerName: String, rightImageId: String, count: Binding<Int>) -> some View {
        HStack(spacing: 16) {
            // Worker image
            Image("population/\(workerName.lowercased())")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .background {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 48, height: 48)
                }
            Spacer()
            VStack(alignment: .center, spacing: 4) {
                Text(viewModel.population.entries[workerName]?.name ?? "?".capitalized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                TextField("0", value: count, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .frame(width: 100)
            }
            
            Spacer()
            
            // Resource icon
            Image(rightImageId)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.quaternary.opacity(0.5))
        }
    }
}

// MARK: - Calculation Section

extension IslandDetailsView {
    @ViewBuilder
    func calculationSection() -> some View {
        if !viewModel.calculatedNeeds.isEmpty {
            IslandCalculationView(calculatedNeeds: viewModel.calculatedNeeds)
        }
    }
}

// MARK: - Side Effects

extension IslandDetailsView {
    func delete() async {
        do {
            try await injected.interactors.islands.delete(island: viewModel.island)
        } catch {
            print("Failed to delete \(error)")
        }
        dismiss()
    }
    
    func save() async {
        do {
            try await injected.interactors.islands.store(island: viewModel.island)
        } catch {
            print("Failed to save \(error)")
        }
    }
}

#Preview {
    IslandDetailsView(island: DBModel.Island.oldWorldExample)
}
