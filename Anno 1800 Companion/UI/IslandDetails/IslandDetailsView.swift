//
//  IslandView.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 29/05/2025.
//

import SwiftUI

struct IslandDetailsView: View {
    @State private(set) var viewModel: ViewModel
    
    var body: some View {
        
        NavigationStack {
            Form {
                // MARK: - Global Section
                
                Section("Global") {
                    TextField("Name", text: $viewModel.island.name)
                    
                    Menu(content: {
                        Picker("Region", selection: $viewModel.island.region) {
                            ForEach(Array(viewModel.regions.entries.keys), id:\.self) { key in
                                HStack {
                                    Image(viewModel.regions.entries[key]!.img)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                    Text(viewModel.regions.entries[key]!.name)
                                }
                                .tag(viewModel.regions.entries[key]!)
                            }
                        }
                    }, label: {
                        Image(viewModel.island.region.img)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        Text(viewModel.island.region.description)
                    })
                    Button("Calculate") {
                        calculate()
                    }
                    .disabled(!isCalculateEnabled)
                    Button("Save") {
                        print("Save")
                    }
                    .disabled(!isSaveEnabled)
                }
                
                // MARK: - The Old World
                
                if viewModel.island.region.id == 1 {
                    Section(header: Text("The Old World")) {
                        workerDisplay(workerName: "farmers", rightImageId: "icons/workforce-farmers", count: $viewModel.island.farmers)
                        workerDisplay(workerName: "workers", rightImageId: "icons/workforce-workers", count: $viewModel.island.workers)
                        workerDisplay(workerName: "artisans", rightImageId: "icons/workforce-artisans", count: $viewModel.island.artisans)
                        workerDisplay(workerName: "engineers", rightImageId: "icons/workforce-engineers", count: $viewModel.island.engineers)
                        workerDisplay(workerName: "investors", rightImageId: "icons/icon-credits", count: $viewModel.island.investors)
                    }
                }
                
                //MARK: - The New World
                
                if viewModel.island.region.id == 2 {
                    
                    Section(header: Text("The New World")) {
                        
                        workerDisplay(workerName: "jornaleros", rightImageId: "icons/workforce-jornaleros", count: $viewModel.island.jornaleros)
                        workerDisplay(workerName: "obreros", rightImageId: "icons/workforce-obreros", count: $viewModel.island.obreros)
                    }
                }
                
                //MARK: - Cape Treylawney
                
                if viewModel.island.region.id == 3 {
                    Section("Cape Treylawney") {
                        workerDisplay(workerName: "farmers", rightImageId: "icons/workforce-farmers", count: $viewModel.island.farmers)
                        workerDisplay(workerName: "workers", rightImageId: "icons/workforce-workers", count: $viewModel.island.workers)
                        workerDisplay(workerName: "artisans", rightImageId: "icons/workforce-artisans", count: $viewModel.island.artisans)
                        workerDisplay(workerName: "engineers", rightImageId: "icons/workforce-engineers", count: $viewModel.island.engineers)
                        workerDisplay(workerName: "investors", rightImageId: "icons/icon-credits", count: $viewModel.island.investors)
                    }
                }
                
                //MARK: - The Arctic
                
                if viewModel.island.region.id == 4 {
                    Section("The Arctics") {
                        workerDisplay(workerName: "explorers", rightImageId: "icons/workforce-explorers", count: $viewModel.island.explorers)
                        workerDisplay(workerName: "technicians", rightImageId: "icons/workforce-technicians", count: $viewModel.island.technicians)
                    }
                }
                
                //MARK: - Enbesa
                
                if viewModel.island.region.id == 5 {
                    Section("Enbesa") {
                        workerDisplay(workerName: "shepherds", rightImageId: "icons/workforce-shepherds", count: $viewModel.island.elders)
                        workerDisplay(workerName: "elders", rightImageId: "icons/workforce-elders", count: $viewModel.island.elders)
                    }
                }
            }
        }
    }
}

private extension IslandDetailsView {
    func workerDisplay(workerName: String, rightImageId: String, count: Binding<Int>) -> some View {
        HStack(alignment: .center) {
            
            Image("population/\(workerName.lowercased())", label: Text(workerName.capitalized))
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            VStack(alignment: .center) {
                Text(workerName.capitalized)
                TextField("Number", value: count, format: .number)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
            }
            Image(rightImageId)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
    }
}

private extension IslandDetailsView {
    var isCalculateEnabled: Bool {
        switch viewModel.island.region.id {
        case 1, 4:
            return viewModel.island.name != "" && viewModel.island.farmers > 50
        case 2, 3, 5:
            return viewModel.island.name != "" && viewModel.island.population > 0
        default:
            return false
        }
    }
    
    var isSaveEnabled: Bool {
        return viewModel.island.name != ""
    }
    
    func calculate() {
        viewModel.calculate()
    }
    
    func save() {
        
    }
}

#Preview {
    IslandDetailsView(viewModel: .init())
}
