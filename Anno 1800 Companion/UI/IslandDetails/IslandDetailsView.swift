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
            .navigationTitle("Island Details")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Calculate", systemImage: "function") {
                            viewModel.calculate()
                        }
                        .disabled(!viewModel.isCalculateEnabled)
                        
                        Button("Save", systemImage: "square.and.arrow.down") {
                            Task {
                                await save()
                            }
                        }
                        .disabled(!viewModel.isSaveEnabled)
                        
                        Divider()
                        
                        Button("Delete", systemImage: "trash", role: .destructive) {
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
                        Button("Done") {
                            dismiss()
                        }
                        .fontWeight(.semibold)
                    }
                }
            }
            .alert("Delete Island", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    Task {
                        await delete()
                    }
                }
            } message: {
                Text("Are you sure you want to delete this island? This action cannot be undone.")
            }
        }
        .onAppear {
            viewModel.calculate()
        }
    }
}

// MARK: - Global Section

private extension IslandDetailsView {
    @ViewBuilder
    func globalSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("General Information")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                // Island name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Island Name")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    TextField("Enter island name", text: $viewModel.island.name)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                }
                
                // Region selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Region")
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
                                    Text(region.description)
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(viewModel.island.region.img)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                            
                            Text(viewModel.island.region.description)
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
                    Button("Calculate") {
                        viewModel.calculate()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(!viewModel.isCalculateEnabled)
                    
                    Button("Save Changes") {
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
            switch viewModel.island.region.id {
            case 1:
                populationCard(title: String(localized:"The Old World"), workers: [
                    ("farmers", "icons/workforce-farmers", $viewModel.island.farmers),
                    ("workers", "icons/workforce-workers", $viewModel.island.workers),
                    ("artisans", "icons/workforce-artisans", $viewModel.island.artisans),
                    ("engineers", "icons/workforce-engineers", $viewModel.island.engineers),
                    ("investors", "icons/icon-credits", $viewModel.island.investors)
                ])
            case 2:
                populationCard(title: String(localized:"The New World"), workers: [
                    ("jornaleros", "icons/workforce-jornaleros", $viewModel.island.jornaleros),
                    ("obreros", "icons/workforce-obreros", $viewModel.island.obreros)
                ])
            case 3:
                populationCard(title: String(localized:"Cape Trelawney"), workers: [
                    ("farmers", "icons/workforce-farmers", $viewModel.island.farmers),
                    ("workers", "icons/workforce-workers", $viewModel.island.workers),
                    ("artisans", "icons/workforce-artisans", $viewModel.island.artisans),
                    ("engineers", "icons/workforce-engineers", $viewModel.island.engineers),
                    ("investors", "icons/icon-credits", $viewModel.island.investors)
                ])
            case 4:
                populationCard(title: String(localized:"The Arctic"), workers: [
                    ("explorers", "icons/workforce-explorers", $viewModel.island.explorers),
                    ("technicians", "icons/workforce-technicians", $viewModel.island.technicians)
                ])
            case 5:
                populationCard(title: "Enbesa", workers: [
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
            
            VStack(alignment: .leading, spacing: 4) {
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
