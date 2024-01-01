//
//  ConfigurationsView.swift
//  SwiftUIGameOfLife
//
//  Created by Van Simmons on 5/31/20.
//  Copyright © 2020 ComputeCycles, LLC. All rights reserved.
//
import SwiftUI
import ComposableArchitecture
import Configuration

public struct ConfigurationsView: View {
    let store: StoreOf<ConfigurationsModel>

    public init(store: StoreOf<ConfigurationsModel>) {
        self.store = store
    }

    public var body: some View {
        // Your problem 3A code starts here.
        NavigationView {
            ZStack{
                Color("configsBackground").ignoresSafeArea()
                WithViewStore(store, observe: { $0 }) { viewStore in
                    VStack {
                        List {
                            ForEachStore(
                                self.store.scope(
                                    state: \.configs,
                                    action: ConfigurationsModel.Action.configuration(id:action:)
                                ),
                                content: ConfigurationView.init(store:)
                            ).listRowBackground(Color("gridBackground")
                                        .opacity(0.5)
                            )
                        }.listStyle(PlainListStyle())
                        
                        ZStack{
                            // spongebob got fetched!!!
                            Image("icons8-spongebob-squarepants")
                                .opacity(store.withState( { state in
                                    state.isFetching ? 0.8 : 0 }))
                                .scaleEffect(viewStore.isFetching ? 2 : 10)
                                .animation(.linear(duration: 1.0), value: viewStore.isFetching)
                            
                            // poor squidword would run away in no time
                            Image("icons8-squidward")
                                .opacity(viewStore.isFetching ? 0.0 : 0.8)
                                .offset(x: viewStore.isFetching ? 500 : 0)
                                .animation(.linear(duration: 1.0), value: viewStore.isFetching)
                            
                        }
                        Spacer()
                        
                        HStack {
                            BubbleButton(text: "Fetch")
                            { viewStore.send(.fetch)}
                            
                            BubbleButton(text: "Clear")
                            { viewStore.send(.clear)}
                        }
                        .padding([.top, .bottom], 8.0)
                    }
                    // Problem 5A goes here
                    .sheet(
                        isPresented: viewStore.binding(
                            get: \.isAdding,
                            send: .stopAdding(true)
                        ),
                        content: {
                            AddConfigurationView.init(store: self.store.scope(
                                state: \.addConfigState,
                                action: ConfigurationsModel.Action.addConfig(action:)
                            )).background(Color("configsBackground"))
                        })
                    // Problem 3B goes here
                    .navigationBarTitle("Configuration")
                    .navigationBarHidden(false)
                    .scrollContentBackground(.hidden)
                }
            // Problem 5B goes here
                .navigationBarItems(
                        trailing:
                            Button(action: {
                                store.send(.add)
                            }) {
                                Text("Add")
                                Image(systemName: "plus.circle.fill").imageScale(.large)
                            }
                    )
            // Problem 3A Ends here
            }.background(Image("squidword_house").resizable().scaledToFill().ignoresSafeArea())
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    let previewState = ConfigurationsModel.State()
    return ConfigurationsView(
        store: Store(
            initialState: previewState,
            reducer: ConfigurationsModel.init
        )
    )
}
