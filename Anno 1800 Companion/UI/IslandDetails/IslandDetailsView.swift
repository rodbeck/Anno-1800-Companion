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
    @State var island: DBModel.Island
    @State private var edit = false
    @State private var isSaveEnabled: Bool = false
    @State private var isCalculateEnabled: Bool = false
    @State private(set) var viewModel: ViewModel
    
    init(island: DBModel.Island) {
        viewModel = .init()
        self.island = island
    }
    
    var body: some View {
        NavigationStack {
            Form {
                globalSection()
                populationSection()
            }
        }
    }
}

// MARK: - Global Section

private extension IslandDetailsView {
    @ViewBuilder
    func globalSection() -> some View {
        Section("Global") {
            TextField("Name", text: $island.name)
            
            Menu(content: {
                Picker("Region", selection: $island.region) {
                    ForEach(RegionEnum.allCases, id:\.self) { region in
                        HStack {
                            Image(region.img)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                            Text(region.description)
                        }
                        .tag(region)
                    }
                }
            }, label: {
                Image(island.region.img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text(island.region.description)
            })
            Button("Calculate") {
                calculate()
            }
            .disabled(!isCalculateEnabled)
            Button("Save") {
                Task {
                    await save()
                }
                dismiss()
            }
            .disabled(!isSaveEnabled)
            Button("Delete") {
                Task {
                    await delete()
                }
                dismiss()
            }
        }
    }
}

// MARK: - Population Display

private extension IslandDetailsView {
    @ViewBuilder
    func populationSection() -> some View {
        switch island.region.id {
        case 1:
            Section(header: Text("The Old World")) {
                workerDisplay(workerName: "farmers", rightImageId: "icons/workforce-farmers", count: $island.farmers)
                workerDisplay(workerName: "workers", rightImageId: "icons/workforce-workers", count: $island.workers)
                workerDisplay(workerName: "artisans", rightImageId: "icons/workforce-artisans", count: $island.artisans)
                workerDisplay(workerName: "engineers", rightImageId: "icons/workforce-engineers", count: $island.engineers)
                workerDisplay(workerName: "investors", rightImageId: "icons/icon-credits", count: $island.investors)
            }
        case 2:
            Section(header: Text("The New World")) {
                workerDisplay(workerName: "jornaleros", rightImageId: "icons/workforce-jornaleros", count: $island.jornaleros)
                workerDisplay(workerName: "obreros", rightImageId: "icons/workforce-obreros", count: $island.obreros)
            }
        case 3:
            Section("Cape Treylawney") {
                workerDisplay(workerName: "farmers", rightImageId: "icons/workforce-farmers", count: $island.farmers)
                workerDisplay(workerName: "workers", rightImageId: "icons/workforce-workers", count: $island.workers)
                workerDisplay(workerName: "artisans", rightImageId: "icons/workforce-artisans", count: $island.artisans)
                workerDisplay(workerName: "engineers", rightImageId: "icons/workforce-engineers", count: $island.engineers)
                workerDisplay(workerName: "investors", rightImageId: "icons/icon-credits", count: $island.investors)
            }
        case 4:
            Section("The Arctics") {
                workerDisplay(workerName: "explorers", rightImageId: "icons/workforce-explorers", count: $island.explorers)
                workerDisplay(workerName: "technicians", rightImageId: "icons/workforce-technicians", count: $island.technicians)
            }
        case 5:
            Section("Enbesa") {
                workerDisplay(workerName: "shepherds", rightImageId: "icons/workforce-shepherds", count: $island.elders)
                workerDisplay(workerName: "elders", rightImageId: "icons/workforce-elders", count: $island.elders)
            }
        default:
            ContentUnavailableView("Unknown region", systemImage: "camera.metering.unknown")
        }
    }
}

private extension IslandDetailsView {
    func workerDisplay(workerName: String, rightImageId: String, count: Binding<Int>) -> some View {
        HStack(alignment: .center, spacing: 16) {
            Image("population/\(workerName.lowercased())", label: Text(workerName.capitalized))
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
            VStack(alignment: .leading, spacing: 4) {
                Text(workerName.capitalized)
                    .font(.body)
                TextField("Number", value: count, format: .number)
                    .multilineTextAlignment(.leading)
                    .keyboardType(.numberPad)
                    .frame(maxWidth: 80)
            }
            Spacer()
            Image(rightImageId)
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
        }
        .padding(.vertical, 4)
    }
}

extension IslandDetailsView {
    func calculate() {
        
    }
    
    func save() async {
        
    }
    
    func delete() async {
        do {
            try await injected.interactors.islands.delete(island: island)
        } catch {
            print("Failed to delete \(error)")
        }
        dismiss()
    }
}

#Preview {
    //IslandDetailsView()
}
