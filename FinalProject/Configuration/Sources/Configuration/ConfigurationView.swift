//
//  ConfigurationView.swift
//  SwiftUIGameOfLife
//
import ComposableArchitecture
import SwiftUI
import GameOfLife

public struct ConfigurationView: View {
    let store: StoreOf<ConfigurationModel>

    public init(store: StoreOf<ConfigurationModel>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationLink(destination: GridEditorView(store: store)){
            WithViewStore(store, observe: { $0 }) { viewStore in
                // Your Problem 3c code goes here.
                    VStack {
                        HStack {
                            Text(viewStore.configuration.title)
                                .font(.system(size: 24.0).monospacedDigit())
                            Spacer()
                        }
                        HStack {
                            Text(viewStore.configuration.shape)
                                .font(.system(size: 14.0))
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                    }
                    // your Problem 3C code ends here.
                }
            
        }
    }
}

#Preview {
    ConfigurationView(
        store: StoreOf<ConfigurationModel>(
            initialState: try! .init(
                configuration: .init(
                    title: "Demo",
                    contents: [[1,1]]
                )
            ),
            reducer: ConfigurationModel.init
        )
    )
}
