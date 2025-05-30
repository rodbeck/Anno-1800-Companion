//
//  IslandView.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 29/05/2025.
//

import SwiftUI

struct IslandDetailsView: View {
    @State private(set) var viewModel: ViewModel
    
    //@State private var name: String = ""
    //@State private var selectedRegion: RegionEnum
    @State private var farmers: Int = 0
    @State private var workers: Int = 0
    @State private var artisans: Int = 0
    @State private var engineers: Int = 0
    @State private var investors: Int = 0
    
    @State private var jornaleros: Int = 0
    @State private var obreros: Int = 0
    
    @State private var explorers: Int = 0
    @State private var technicians: Int = 0
    
    @State private var sheperds: Int = 0
    @State private var elders: Int = 0
    
    var body: some View {
        
        
        NavigationStack {
            Form {
                // MARK: - Global Section
                
                Section("Global") {
                    TextField("Name", text: $viewModel.island.name)
                    Menu(content: {
                        Picker("Region", selection: $viewModel.island.region) {
                            ForEach(RegionEnum.allCases) { option in
                                HStack {
                                    Image(option.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 10, height: 10)
                                    Text(String(describing: option))
                                }
                            }
                        }
                    }, label: {
                        Image(viewModel.island.region.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        Text(viewModel.island.region.description)
                    })
                    Button("Calculate") {
                        print("Calculate")
                    }
                }
                
                // MARK: - The Old World
                
                if viewModel.island.region == .oldWorld {
                    Section(header: Text("The Old World")) {
                        HStack(alignment: .center) {
                            Image("population/farmers", label: Text("Farmers"))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            VStack(alignment: .center) {
                                Text("Farmers")
                                TextField("Number", value: $viewModel.island.farmers, format: .number)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                            }
                            Image("icons/workforce-farmers")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                        
                        HStack(alignment: .center) {
                            Image("population/workers", label: Text("Workers"))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            VStack(alignment: .center) {
                                Text("Workers")
                                TextField("Number", value: $viewModel.island.workers, format: .number)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                            }
                            Image("icons/workforce-workers")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                        
                        HStack(alignment: .center) {
                            Image("population/artisans", label: Text("Artisans"))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            VStack(alignment: .center) {
                                Text("Artisans")
                                TextField("Number", value: $viewModel.island.artisans, format: .number)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                            }
                            Image("icons/workforce-artisans")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                        
                        HStack(alignment: .center) {
                            Image("population/engineers", label: Text("Engineers"))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            VStack(alignment: .center) {
                                Text("Engineers")
                                TextField("Number", value: $viewModel.island.engineers, format: .number)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                            }
                            Image("icons/workforce-engineers")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                        
                        HStack(alignment: .center) {
                            Image("population/investors", label: Text("Investors"))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            VStack(alignment: .center) {
                                Text("Investors")
                                TextField("Number", value: $viewModel.island.investors, format: .number)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                            }
                            Image("icons/icon-credits")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                
                //MARK: - The New World
                
                if viewModel.island.region == .newWorld {
                    Section("The New World") {
                        HStack(alignment: .center) {
                            Image("population/jornaleros", label: Text("Jornaleros"))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            VStack(alignment: .center) {
                                Text("Jornaleros")
                                TextField("Number", value: $viewModel.island.jornaleros, format: .number)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                            }
                            Image("icons/workforce-jornaleros")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                        
                        HStack(alignment: .center) {
                            Image("population/obreros", label: Text("Obreros"))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            VStack(alignment: .center) {
                                Text("Obreros")
                                TextField("Number", value: $viewModel.island.obreros, format: .number)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                            }
                            Image("icons/workforce-obreros")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                        
                    }
                }
                
                //MARK: - The Arctic
                
                if viewModel.island.region == .theArctic {
                    
                    HStack(alignment: .center) {
                        Image("population/explorers", label: Text("Explorers"))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .center) {
                            Text("Explorers")
                            TextField("Number", value: $viewModel.island.explorers, format: .number)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                        }
                        Image("icons/workforce-explorers")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                    
                    HStack(alignment: .center) {
                        Image("population/technicians", label: Text("Technicians"))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .center) {
                            Text("Technicians")
                            TextField("Number", value: $viewModel.island.technicians, format: .number)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                        }
                        Image("icons/workforce-technicians")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }
                
                //MARK: - Enbesa
                
                if viewModel.island.region == .enbesa {
                    
                    HStack(alignment: .center) {
                        Image("population/shepherds", label: Text("Shepherds"))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .center) {
                            Text("Shepherds")
                            TextField("Number", value: $viewModel.island.sheperds, format: .number)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                        }
                        Image("icons/workforce-shepherds")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                    
                    HStack(alignment: .center) {
                        Image("population/elders", label: Text("Elders"))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .center) {
                            Text("Elders")
                            TextField("Number", value: $viewModel.island.elders, format: .number)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                        }
                        Image("icons/workforce-elders")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }
            }
        }
    }
}

#Preview {
    IslandDetailsView(viewModel: .init(island: .enbesaExample))
}
