//
//  SimulationView.swift
//  SwiftUIGameOfLife
//
import SwiftUI
import ComposableArchitecture
import Grid

public struct SimulationView: View {
    let store: StoreOf<SimulationModel>

    public init(store: StoreOf<SimulationModel>) {
        self.store = store
    }


    public var body: some View {
        NavigationView {
            ZStack{
                Color("simBackground").ignoresSafeArea()
                WithViewStore(store, observe: { $0 }) { viewStore in
                    VStack {
                        GeometryReader { g in
                            if g.size.width < g.size.height {
                                self.verticalContent(for: viewStore, geometry: g)
                            } else {
                                self.horizontalContent(for: viewStore, geometry: g)
                            }
                        }
                    }
                    .navigationBarTitle("Simulation")
                    .navigationBarHidden(false)
                    // Problem 6A - your answer goes here.
                    .onAppear {
                        viewStore.send(SimulationModel.Action.appear)
                    }
                    .onDisappear {
                        viewStore.send(SimulationModel.Action.disappear)
                    }
                }
            }.background(Image("pinapple").resizable().scaledToFill().ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func verticalContent(
        for viewStore: ViewStoreOf<SimulationModel>,
        geometry g: GeometryProxy
    ) -> some View {
        VStack {
            Spacer()
            HStack{
                Spacer()
                InstrumentationView(
                    store: self.store,
                    width: g.size.width * 0.8
                )
                .frame(height: g.size.height * 0.35)
                .padding(.bottom, 8.0)
                Spacer()
            }
            GridView(
                store: self.store.scope(
                    state: \.gridState,
                    action: SimulationModel.Action.grid(action:)
                )
            )
        }
    }

    func horizontalContent(
        for viewStore: ViewStoreOf<SimulationModel>,
        geometry g: GeometryProxy
    ) -> some View {
        HStack {
            Spacer()

            VStack{
                Spacer()
                InstrumentationView(
                    store: self.store,
                    width: (g.size.width - g.size.height) * 0.9
                )
                Spacer()
            }
            
            Divider()
            GridView(
                store: self.store.scope(
                    state: \.gridState,
                    action: SimulationModel.Action.grid(action:)
                )
            )
            .frame(width: g.size.height * 0.9, alignment: .trailing)
            Spacer()
        }
    }
}

#Preview {
    let previewState = SimulationModel.State()
    return SimulationView(
        store: Store(
            initialState: previewState,
            reducer: SimulationModel.init
        )
    )
}
