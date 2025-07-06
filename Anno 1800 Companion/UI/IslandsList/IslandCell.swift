//
//  IslandCell.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 30/05/2025.
//

import SwiftUI

struct IslandCell: View {
    let island: DBModel.Island
    @Environment(\.locale) var locale: Locale
    
    var body: some View {
        HStack {
            Text(island.name)
            Spacer()
            Text(island.population.description)
            Spacer()
            Image(island.region.img)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
        
    }
}

#Preview {
    IslandCell(island: .newWorldExample)
}
