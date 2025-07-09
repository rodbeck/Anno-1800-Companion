//
//  AboutView.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 09/07/2025.
//

import SwiftUI

struct AboutView: View {
    @State private var selectedLanguage = AppLanguageManager.shared.currentLanguage
    @State private var isUsingCustomLanguage = AppLanguageManager.shared.isUsingCustomLanguage
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.systemGroupedBackground), Color(.systemBackground)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                Image(systemName: "map")
                    .font(.system(size: 64))
                    .foregroundColor(.blue)
                
                VStack(spacing: 8) {
                    Text(L("Thank you for using Calculator - For Anno 1800"))
                    Text(L("This application was developed by a fan, and is free and open source"))
                    Text(L("It is not affiliated with Ubisoft"))
                    Text(L("Don't hesitate to review the application in the AppStore and suggest new feature"))
                    Link("Support", destination: URL(string: "https://codeskulpt-help.freshdesk.com/support/home")!)
                }
                
                Button(("Ok")) {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
            }
            .padding(32)
            .padding(.top, 60)
        }
        .toolbar {
            // Groupe les boutons à droite
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
                                if isUsingCustomLanguage &&
                                    selectedLanguage == language.id {
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
        }
        .onLanguageChange {
            selectedLanguage = AppLanguageManager.shared.currentLanguage
            isUsingCustomLanguage = AppLanguageManager.shared.isUsingCustomLanguage
        }
    }
}

#Preview {
    AboutView()
}
