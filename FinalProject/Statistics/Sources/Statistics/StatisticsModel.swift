//
//  Statistics.swift
//  SwiftUIGameOfLife
//
import ComposableArchitecture
import GameOfLife

@Reducer
public struct StatisticsModel {
    public struct State: Equatable, Codable {
        public var statistics: Grid.Statistics = Grid.Statistics.init()
        public var angle: Double = 0.0
        public mutating func changeAngle()-> Void { angle = 360.0 - angle}

        public init(statistics: Grid.Statistics = Grid.Statistics.init()) {
            self.statistics = statistics
        }
    }
    
    public enum Action {
        case update(grid: Grid)
        case reset
        case rotate
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .update(grid: let grid):
                    state.statistics = state.statistics.add(grid)
                    return .none
                case .reset:
                    state.changeAngle()
                    state.statistics = Grid.Statistics.init()
                    return .none
                case .rotate:
                    state.changeAngle()
                    return .none
            }
        }
    }
}
