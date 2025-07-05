//
//  Anno_1800_CompanionApp.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 24/05/2025.
//

import EnvironmentOverrides
import SwiftUI

@main
struct MainApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            appDelegate.rootView
        }
    }
}

extension AppEnvironment {
    var rootView: some View {
        VStack {
            if isRunningTests {
                Text("Running unit tests")
            } else {
                ContentView()
                    .modelContainer(modelContainer)
                    .inject(diContainer)
                if modelContainer.isStub {
                    Text("⚠️ There is an issue with local database")
                        .font(.caption2)
                }
            }
        }
    }
}
