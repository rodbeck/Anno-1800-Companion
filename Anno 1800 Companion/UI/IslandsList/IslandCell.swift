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
        HStack(spacing: 16) {
            // Image de région avec effet glassmorphism
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 50, height: 50)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                
                Image(island.region.img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(island.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    Image(systemName: "person.3.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(island.population.formatted())")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 1)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        IslandCell(island: .newWorldExample)
        IslandCell(island: .enbesaExample)
        IslandCell(island: .theArcticExample)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
