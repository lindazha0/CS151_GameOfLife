//
//  SwiftUIGameOfLifeApp.swift
//  FinalProject
//

import Foundation
import SwiftUI
import ComposableArchitecture

@main
struct SwiftUIGameOfLife: App {
    let store = Store(
        initialState: ApplicationModel.State(),
        reducer: ApplicationModel.init
    )
    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
