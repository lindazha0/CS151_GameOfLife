//
//  GridModel.swift
//  Lecture18
//
//  Created by Van Simmons on 11/2/23.
//

import ComposableArchitecture
import GameOfLife

// for animation process
enum Phase: CaseIterable {
    case start, middle, end
    var shakeAngle: Double {
        switch self {
        case .start: 0
        case .middle: -60
        case .end: 60
        }
    }
}

public struct GridModel: Reducer {
    public struct State: Equatable, Codable {
        var lineWidth: Double
        var inset: Double
        public var grid: GameOfLife.Grid
        public var history: GameOfLife.Grid.History
        
        // for button animation
        public var step = false
        public var resetempty = false
        

        public init(
            lineWidth: Double = 2.0,
            inset: Double = 2.0,
            history: Grid.History = Grid.History(),
            grid: GameOfLife.Grid = .init()
        ) {
            self.lineWidth = grid.size.rows > 40 ? 1.0 : lineWidth
            self.inset = grid.size.rows > 40 ? 0.0 : inset
            self.grid = grid
            self.history = history
            self.history.add(grid)
        }
    }

    public enum Action {
        case step
        case toggle(row: Int, col: Int)
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .step:
                    return .none
                case let .toggle(row: row, col: col):
                    state.grid.toggle(row, col)
                    return .none
            }
        }
    }
}
