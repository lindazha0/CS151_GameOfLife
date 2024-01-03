//
//  Application.swift
//  SwiftUIGameOfLife
//

import ComposableArchitecture
import Combine
import Simulation
import Configurations
import Configuration
import Statistics
import Foundation
import GameOfLife

@Reducer
struct ApplicationModel {
    struct State: Equatable {
        var selectedTab = Tab.simulation
        var simulationState = SimulationModel.State()
        var configurationState = ConfigurationsModel.State()
        var statisticsState = StatisticsModel.State()
    }

    enum Action {
        case setSelectedTab(tab: Tab)
        case simulation(action: SimulationModel.Action)
        case configurations(action: ConfigurationsModel.Action)
        case statistics(action: StatisticsModel.Action)
    }

    enum Tab {
        case simulation
        case configuration
        case statistics
    }

    init() { }

    var body: some ReducerOf<Self> {
        Scope(
            state: \.simulationState,
            action: /ApplicationModel.Action.simulation,
            child: SimulationModel.init
        )

        Scope(
            state: \.configurationState,
            action: /ApplicationModel.Action.configurations,
            child: ConfigurationsModel.init
        )

        Scope(
            state: \.statisticsState,
            action: /ApplicationModel.Action.statistics,
            child: StatisticsModel.init
        )

        /// Main reducer
        Reduce { state, action in
            switch action {
                case .setSelectedTab(let tab):
                    state.selectedTab = tab
                case .simulation(action: .tick):
                    state.statisticsState = .init(
                        statistics: state.statisticsState.statistics.add(
                            state.simulationState.gridState.grid
                        )
                    )
                    return .none
                case .simulation(action: .resetGridToRandom), .simulation(action: .resetGridToEmpty):
                    return Effect.publisher { Just(ApplicationModel.Action.statistics(action: .reset)) }
                case let .configurations(action: .configuration(_, .simulate(grid))):
                    state.simulationState.gridState.grid = grid
                    return .none
                default:
                    ()
            }
            return .none
        }
    }
}
