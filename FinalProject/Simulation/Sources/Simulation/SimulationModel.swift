//
//  Simulation.swift
//  SwiftUIGameOfLife
//
import ComposableArchitecture
import Combine
import Dispatch
import Foundation
import Grid
import GameOfLife

@Reducer
public struct SimulationModel {
    public struct State: Equatable, Codable {
        public var gridState: GridModel.State
        public var isRunningTimer = false
        public var wasRunningTimer = false
        public var shouldRestartTimer = false
        public var timerInterval = 0.5

        public init(gridState: GridModel.State = GridModel.State(grid: .init())) {
            self.gridState = gridState
        }
    }

    public enum Action {
        case appear
        case disappear
        case setGridSize(Int)
        case update(grid: Grid)
        case setTimerInterval(Double)
        case stepGrid
        case resetGridToEmpty
        case resetGridToRandom
        case tick
        case startTimer
        case stopTimer
        case setShouldRestartTimer(Bool)
        case toggleTimer(Bool)
        case grid(action: GridModel.Action)
    }

    enum Identifiers: Hashable {
        case simulationTimer
        case simulationCancellable
    }

    public static let scheduler: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()

    public static func timerPublisher(
        _ period: Double
    ) -> () -> AnyPublisher<SimulationModel.Action, Never> {
        {
            Timer.publish(every: period, on: RunLoop.main, in: .common)
                .autoconnect()
                .map { _ in .tick }
                .eraseToAnyPublisher()
        }
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Scope(
            state: \.gridState,
            action: /SimulationModel.Action.grid(action:),
            child: GridModel.init
        )

        Reduce { state, action in
            switch action {
                // Your Problem 6B code modifies the two cases below
                case .appear:
                    // if was_running, restart - .startTimer and .stopTimer called internally)
                    if state.shouldRestartTimer == true {
                        return Effect.publisher { Just(.setShouldRestartTimer(false)) }
                    }
                    return .none
                case .disappear:
                    // logic: if running -> stop on leave -> restart on arrival if was_running
                    state.wasRunningTimer = state.isRunningTimer
                    if state.wasRunningTimer == true {
                        return Effect.publisher { Just(.setShouldRestartTimer(true)) }
                    }
                    return .none
                case .setGridSize(let newSize):
                    state.gridState.grid = Grid(newSize, newSize, Grid.Initializers.empty)
                    state.gridState.history.reset(with: state.gridState.grid)
                    return .none
                case .update(grid: let grid):
                    state.gridState.grid = grid
                    state.gridState.history = Grid.History()
                    state.gridState.history.add(state.gridState.grid)
                    return .none
                case .setTimerInterval(let interval):
                    state.isRunningTimer = false
                    state.timerInterval = interval == 0.0 ? 0.01 : interval
                    return Effect.publisher { Just(.stopTimer) }
                case .resetGridToEmpty:
                // Empty Button
                    state.isRunningTimer = false
                    state.gridState.resetempty.toggle()
                    state.gridState.grid = Grid(
                        state.gridState.grid.size.rows,
                        state.gridState.grid.size.cols,
                        Grid.Initializers.empty
                    )
                    state.gridState.history = Grid.History()
                    state.gridState.history.add(state.gridState.grid)
                    return Effect.publisher { Just(.stopTimer) }
                case .resetGridToRandom:
                // Random Button
                    state.gridState.step.toggle()
                    state.isRunningTimer = false
                    state.gridState.grid = Grid(
                        state.gridState.grid.size.rows,
                        state.gridState.grid.size.cols,
                        Grid.Initializers.random
                    )
                    state.gridState.history = Grid.History()
                    state.gridState.history.add(state.gridState.grid)
                    return Effect.publisher { Just(.stopTimer) }
                case .stepGrid:
                // Step button - animation for P8
                    state.gridState.step.toggle() // toggle animation trigger
                    state.isRunningTimer = false
                    state.gridState.grid = state.gridState.grid.next
                    state.gridState.history = Grid.History()
                    return Effect.publisher { Just(.stopTimer) }
                case .tick:
                    state.gridState.grid = state.gridState.grid.next
                    state.gridState.history.add(state.gridState.grid)
                    return state.gridState.history.cycleLength == .none
                    ? .none
                    : Effect.publisher { Just(.stopTimer) }
                case .startTimer:
                    state.gridState.history.reset(with: state.gridState.grid)
                    state.isRunningTimer = true
                    return Effect
                        .publisher(SimulationModel.timerPublisher(state.timerInterval))
                        .cancellable(id: SimulationModel.Identifiers.simulationCancellable)
                case .stopTimer:
                    state.isRunningTimer = false
                    return .cancel(id: SimulationModel.Identifiers.simulationCancellable)
                case .setShouldRestartTimer(let shouldRestart):
                    state.shouldRestartTimer = shouldRestart
                    return Effect.publisher { [state] in
                        (state.shouldRestartTimer ? Just(.stopTimer) : Just(.startTimer))
                    }
                case .toggleTimer(let onOff):
                    return Effect.publisher { Just(onOff ? .startTimer : .stopTimer) }
                case .grid(action:):
                    return .none
            }
        }
    }
}
