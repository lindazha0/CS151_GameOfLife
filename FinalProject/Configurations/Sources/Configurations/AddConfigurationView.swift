//
//  AddConfigurationView.swift
//  FinalProject
//

import SwiftUI
import ComposableArchitecture
import Combine
import Theming
import GameOfLife

struct AddConfigurationView: View {
    var store: StoreOf<AddConfigModel>

    init(store: StoreOf<AddConfigModel>) {
        self.store = store
    }
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                VStack {
                    //Problem 5C Goes inside the following HStacks...
                    HStack {
                        Spacer()
                        Text("Title:")
                            .foregroundColor(Color.gray)
                            .padding(.trailing, 8.0)
                            .frame(alignment: .leading)
                        Spacer()
                        TextField("Input Config Title", text: viewStore.binding(
                            get: \.title,
                            send: AddConfigModel.Action.updateTitle
                        ))
                        .disableAutocorrection(true)
                        
                    }.textFieldStyle(.roundedBorder)
                    HStack {
                        Spacer()
                        Text("Size:")
                            .foregroundColor(Color.gray)
                            .padding(.trailing, 8.0)
                            .frame(width: 200, alignment: .leading)
                        Spacer()
                         CounterView(store: self.store.scope(
                            state: \.counterState,
                            action: AddConfigModel.Action.counter(action:)
                            )
                         )
                    }
                }
                .padding()
                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2.0))
                .padding(.bottom, 24.0)

                HStack {
                    Spacer()
                    // Problem 5D - your answer goes in the following buttons
                    ThemedButton(text: "Save") {
                        do {
                            let grid = try GameOfLife.Grid.Configuration.init(
                                title: viewStore.title,
                                rows: viewStore.counterState.count,
                                cols: viewStore.counterState.count)
                            store.send(.ok(grid))
                        } catch {
                            print("sth wrong with grid config init!")
                        }
                    }
                    ThemedButton(text: "Cancel") {
                        store.send(.cancel)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 36.0)
            .padding(.horizontal, 24.0)
            .font(.title)
        }
    }
}

#Preview {
    AddConfigurationView(
        store: StoreOf<AddConfigModel>(
            initialState: .init(
                title: "",
                counterState: .init(count: 10)
            ),
            reducer: AddConfigModel.init
        )
    )
}
