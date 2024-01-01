//
//  StatisticsView.swift
//  SwiftUIGameOfLife
//
import SwiftUI
import ComposableArchitecture
import Theming

public struct StatisticsView: View {
    let store: StoreOf<StatisticsModel>
    var viewStore: ViewStoreOf<StatisticsModel>

    public init(store: StoreOf<StatisticsModel>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: { $0 })
    }
    
    public var body: some View {
        NavigationView {
            ZStack{
                Color("statsBackground").ignoresSafeArea()
                VStack {
                    Button(action: {
                        store.send(StatisticsModel.Action.rotate)
                    })
                    {
                        Image("icons8-patrick-star")
                            .padding(10)
                            .rotationEffect(.degrees(viewStore.angle))
                            .animation(.easeInOut(duration: 1.0).repeatCount(2), value: viewStore.angle)
                    }
                    
                    // form
                    VStack {
                        Form {
                            // Your Problem 7A code starts here
                            FormLine(title: "Steps 👑", value: viewStore.statistics.steps)
                            FormLine(title: "Alive 🌈", value: viewStore.statistics.alive)
                            FormLine(title: "Born 🧚🏻", value: viewStore.statistics.born)
                            FormLine(title: "Died 🥀", value: viewStore.statistics.died)
                            FormLine(title: "Empty 🫧", value: viewStore.statistics.empty)
                        }
                        Spacer()
                        ThemedButton(text: "Reset") {
                            self.viewStore.send(.reset)
                        }
                    }
                    .onAppear{
                        self.viewStore.send(.rotate)
                    }
                    .padding(.bottom, 24.0)
                    .scrollContentBackground(.hidden)
                    
                }
                .navigationBarTitle(Text("Statistics"))
            }.background(Image("patrick_house").resizable().scaledToFill().ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    let previewState = StatisticsModel.State()
    return StatisticsView(
        store: Store(
            initialState: previewState,
            reducer: StatisticsModel.init
        )
    )
}
