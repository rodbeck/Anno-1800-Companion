//
//  AppDelegate.swift
//  Anno 1800 Companion
//
//  Created by Rodolphe Beck on 05/07/2025.
//

import UIKit
import SwiftUI
import Combine
import Foundation

@MainActor
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private lazy var environment = AppEnvironment.bootstrap()
    
    var rootView: some View {
        environment.rootView
    }

}
