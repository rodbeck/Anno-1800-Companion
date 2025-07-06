//
//  IslandCalculationView.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 04/07/2025.
//

import SwiftUI

struct IslandCalculationView: View {
    var calculatedNeeds: [ProductionNeed] = []
    
    var body: some View {
        if !calculatedNeeds.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text("Production Summary")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 1), spacing: 12) {
                    ForEach(calculatedNeeds, id: \.goodName) { need in
                        ProductionNeedCard(need: need)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
    }
}

struct ProductionNeedCard: View {
    let need: ProductionNeed
    
    var body: some View {
        HStack(spacing: 16) {
            // Building icon avec effet glassmorphism
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .frame(width: 60, height: 60)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                
                Image("buildings/\(need.img)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("^[\(need.buildingsNeeded) \(need.producerName)](inflect: true)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Image(systemName: "building.2")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Production facility")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Circular progress avec design moderne
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 6)
                    .frame(width: 56, height: 56)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(need.usagePercentage))
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 56, height: 56)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: need.usagePercentage)
                
                VStack(spacing: 0) {
                    Text("\(Int(need.usagePercentage * 100))")
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("%")
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
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
    ScrollView {
        IslandCalculationView(calculatedNeeds: [
            // Exemple de données pour la preview
            ProductionNeed(
                populationType: "",
                goodName: "Bread",
                producerName: "Bakery",
                residences: 2,
                consumptionPerResident: 3,
                totalConsumptionPerMin: 2,
                productionPerMin: 2,
                buildingsNeeded: 1,
                usagePercentage: 2,
                img: "workers/bread"
            ),
            ProductionNeed(
                populationType: "",
                goodName: "Beer",
                producerName: "Brewery",
                residences: 2,
                consumptionPerResident: 3,
                totalConsumptionPerMin: 2,
                productionPerMin: 2,
                buildingsNeeded: 1,
                usagePercentage: 2,
                img: "workers/beer"
            )
        ])
    }
    .background(Color(.systemGroupedBackground))
}
