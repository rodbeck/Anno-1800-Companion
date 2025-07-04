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
        VStack {
            if calculatedNeeds.count > 0 {
                List(calculatedNeeds, id:\.goodName) { need in
                    HStack {
                        Text("\(need.producerName)")
                        Text("\(need.buildingsNeeded)")
                        Text("\(Int(need.usagePercentage*100))%")
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
