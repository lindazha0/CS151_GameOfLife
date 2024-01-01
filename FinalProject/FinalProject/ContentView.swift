//
//  ContentView.swift
//  SwiftUIGameOfLife
//

import SwiftUI
import ComposableArchitecture
import Simulation
import Configurations
import Statistics

struct ContentView: View {
    var store: StoreOf<ApplicationModel>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView(selection: viewStore.binding(
                get: \.selectedTab,
                send: ApplicationModel.Action.setSelectedTab(tab:)
            )) {
                self.simulationView()
                    .tag(ApplicationModel.Tab.simulation)
                self.configurationsView()
                    .tag(ApplicationModel.Tab.configuration)
                self.statisticsView()
                    .tag(ApplicationModel.Tab.statistics)
            }
            .accentColor(Color("accent"))
        }
    }

    private func simulationView() -> some View {
        SimulationView(
            store: self.store.scope(
                state: \.simulationState,
                action: ApplicationModel.Action.simulation(action:)
            )
        )
        .tabItem {
            // P1: change tab icon
            Image(systemName: "sparkles.tv")
            Text("Simulation")
        }
    }

    private func configurationsView() -> some View {
        ConfigurationsView(
            store: self.store.scope(
                state: \.configurationState,
                action: ApplicationModel.Action.configurations(action:)
            )
        )
        .tabItem {
            // P1: change tab icon
            Image(systemName: "gear.badge")
            Text("Configuration")
        }
    }

    private func statisticsView() -> some View {
        StatisticsView(
            store: store.scope(
                state: \.statisticsState,
                action: ApplicationModel.Action.statistics(action:)
            )
        )
       .tabItem {
           // P1: change tab icon
            Image(systemName: "chart.line.uptrend.xyaxis")
            Text("Statistics")
        }
    }
}

#Preview {
    let previewState = ApplicationModel.State()
    return ContentView(
        store: Store(
            initialState: previewState,
            reducer: ApplicationModel.init
        )
    )
}
