//
//  GridEditorView.swift
//  GameOfLife
//

import Foundation
import SwiftUI
import ComposableArchitecture
import GameOfLife
import Grid
import Theming


private func shorten(to g: GeometryProxy, by: CGFloat = 0.92) -> CGFloat {
    min(min(g.size.width, g.size.height) * by, g.size.height - 120.0)
}

public struct GridEditorView: View {
    var store: StoreOf<ConfigurationModel>

    public init(store: StoreOf<ConfigurationModel>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Spacer()
                // Problem 4A - your code goes here
                GridView(
                    store: self.store.scope(
                        state: \.gridState,
                        action: ConfigurationModel.Action.grid(action:)
                    )
                )
                
                self.themedButton
                Spacer()
            }
            .background(Color("configsBackground"))
            .navigationBarTitle(viewStore.configuration.title)
            .navigationBarHidden(false)
            .frame(alignment: .center)
        }
    }
}

// MARK: Subviews
extension GridEditorView {
    var themedButton: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ThemedButton(text: "Simulate") {
                // Problem 4B - your code goes here
                viewStore.send(.simulate(viewStore.gridState.grid))
            }
        }
    }
}

#Preview {
    let grid = Grid(10, 10, Grid.Initializers.random)
    let previewState = ConfigurationModel.State(
        configuration: try! .init(
            title: "Example",
            contents: grid.contents
        ),
        gridState: .init(grid: grid),
        index: 0
    )

    return GridEditorView(
        store: Store(
            initialState: previewState,
            reducer: ConfigurationModel.init
        )
    )
}
