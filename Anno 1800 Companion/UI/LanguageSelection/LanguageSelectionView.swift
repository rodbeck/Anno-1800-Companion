//
//  LanguageSelectionView.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 07/07/2025.
//

import SwiftUI

struct LanguageSelectionView: View {
    @State private var selectedLanguage: String = AppLanguageManager.shared.currentLanguage
    @State private var useSystemLanguage: Bool = !AppLanguageManager.shared.isUsingCustomLanguage
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Language Settings")) {
                    Toggle("Use System Language", isOn: $useSystemLanguage)
                        .onChange(of: useSystemLanguage) { value in
                            if value {
                                AppLanguageManager.shared.resetToSystemLanguage()
                                selectedLanguage = AppLanguageManager.shared.systemLanguage
                            }
                        }
                    
                    if !useSystemLanguage {
                        Picker("Select Language", selection: $selectedLanguage) {
                            ForEach(Language.availableLanguages) { language in
                                HStack {
                                    Text(language.nativeName)
                                    Spacer()
                                    Text(language.name)
                                        .foregroundColor(.secondary)
                                }
                                .tag(language.id)
                            }
                        }
                        .pickerStyle(DefaultPickerStyle())
                        .onChange(of: selectedLanguage) { value in
                            AppLanguageManager.shared.currentLanguage = value
                        }
                    }
                }
                
                Section(header: Text("Current Settings")) {
                    HStack {
                        Text("System Language")
                        Spacer()
                        Text(languageName(for: AppLanguageManager.shared.systemLanguage))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("App Language")
                        Spacer()
                        Text(languageName(for: AppLanguageManager.shared.currentLanguage))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Language")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func languageName(for code: String) -> String {
        return Language.availableLanguages.first { $0.id == code }?.nativeName ?? code
    }
}

// Vue pour intégrer dans les paramètres
struct LanguageSettingsRow: View {
    var body: some View {
        NavigationLink(destination: LanguageSelectionView()) {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)
                
                Text("Language")
                
                Spacer()
                
                Text(languageName(for: AppLanguageManager.shared.currentLanguage))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func languageName(for code: String) -> String {
        return Language.availableLanguages.first { $0.id == code }?.nativeName ?? code
    }
}

#Preview {
    LanguageSelectionView()
}
