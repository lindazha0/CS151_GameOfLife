//
//  Grid.swift
//
//
//  Created by Van Simmons on 11/1/23.
//

private func norm(_ val: Int, to size: Int) -> Int {
    ((val % size) + size) % size
}

// implement the wrap-around rules of Conway's Game of Life
private func add(_ p: Grid.Position) -> (Grid.Offset) -> Grid.Offset {
    { o in
        Grid.Offset(
            row: norm(p.offset.row + o.row, to: p.size.rows),
            col: norm(p.offset.col + o.col, to: p.size.cols)
        )
    }
}

// MARK: Public API
public enum CellState: Int, RawRepresentable, Equatable {
    case empty, alive, born, died
    
    static var aliveStates: [Self] { [.born, .alive] }
    public var isAlive: Bool { Self.aliveStates.contains(self) }
    public var toggled: CellState {
        switch self {
            case .born, .alive: .died
            case .died, .empty: .born
        }
    }
}

public struct Grid: Equatable, Hashable, Codable {
    public typealias CellInitializer = (Int, Int) -> CellState
    public typealias Size = (rows:   Int,    cols: Int)
    var state: [[CellState]]


    public init(_ rows: Int = 10, _ cols: Int = 10, _ initializer: CellInitializer = Initializers.empty) {
        state = (0 ..< rows).map { row in (0 ..< cols).map { col in
            initializer(row, col)
        } }
    }

    public struct Initializers {
        public static let empty: CellInitializer = { _,_ in .empty }
        public static let random: CellInitializer = { _,_ in
                .init(rawValue: Int.random(in: 0 ..< 4)) ?? CellState.empty
        }
    }

    public struct Offset {
        var row: Int
        var col: Int
    }

    public var size: (rows: Int, cols: Int) {
        (rows: self.state.count, cols: self.state[0].count)
    }

    public subscript(row: Int, col: Int) -> CellState {
        get { self.state[norm(row, to: size.rows)][norm(col, to: size.cols)] }
        set { self.state[norm(row, to: size.rows)][norm(col, to: size.cols)] = newValue }
    }

    public mutating func toggle(_ row: Int, _ col: Int) -> Void {
        self[row, col] = self[row, col].toggled
    }

    public var next: Self { Self(size.rows, size.cols, nextStateOf(row:col:)) }

    func count(_ states: [CellState], `in` offsets: [Offset]) -> Int {
        offsets.reduce(0) { states.contains(self[$1.row, $1.col]) ? $0 + 1 : $0 }
    }
}

private extension Grid {
    static let offsets: [Offset] = [
        Offset(row: -1, col: -1), Offset(row: -1, col: 0), Offset(row: -1, col: 1),
        Offset(row:  0, col: -1),                          Offset(row:  0, col: 1),
        Offset(row:  1, col: -1), Offset(row:  1, col: 0), Offset(row:  1, col: 1)
    ]
}

private extension Grid {
    typealias Position = (offset: Offset, size: Size)

    func isAlive(_ row: Int, _ col: Int) -> Bool {
        self[row, col].isAlive
    }

    func neighborsOf(_ row: Int, _ col: Int) -> [Offset] {
        let position = Position(offset: Grid.Offset(row: row, col: col), size: self.size)
        return Self.offsets.map(add(position))
    }

    func nextStateOf(row: Int, col: Int) -> CellState {
        switch count(CellState.aliveStates, in: neighborsOf(row, col)) {
            case 3: return isAlive(row, col) ? .alive : .born
            case 2 where isAlive(row, col): return .alive
            default: return isAlive(row, col) ? .died : .empty
        }
    }
}
