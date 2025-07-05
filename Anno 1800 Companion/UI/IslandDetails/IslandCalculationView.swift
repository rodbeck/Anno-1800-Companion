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
        if calculatedNeeds.count > 0 {
            Section(header: Text("Production Summary").font(.title2).bold()) {
                ForEach(calculatedNeeds, id: \.goodName) { need in
                    HStack {
                        VStack(alignment: .leading) {
                            Image("buildings/\(need.img)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36, height: 36)
                            Text("^[\(need.buildingsNeeded) \(need.producerName)](inflect: true)")
                                .font(.subheadline)
                        }
                        Spacer()
                        ZStack {
                            Circle()
                                .stroke(lineWidth: 4)
                                .opacity(0.3)
                                .foregroundColor(.blue)
                            Circle()
                                .trim(from: 0.0, to: CGFloat(need.usagePercentage))
                                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                                .foregroundColor(.blue)
                                .rotationEffect(Angle(degrees: -90))
                            Text("\(Int(need.usagePercentage * 100))%")
                                .font(.caption)
                                .bold()
                        }
                        .frame(width: 40, height: 40)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

#Preview {
    IslandCalculationView()
}
