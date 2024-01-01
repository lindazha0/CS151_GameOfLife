//
//  GridCells.swift
//  Lecture16
//
//  Created by Van Simmons on 10/26/23.
//

import ComposableArchitecture
import GameOfLife
import SwiftUI



extension GameOfLife.CellState {
    var color: Color {
        switch self {
            case .alive: return Color("alive")
            case .born: return Color("born")
        case .died: return Color("died").opacity(0.4)
            case .empty: return Color.clear
        }
    }
}

struct GridCells: View {
    let rows: Int
    let cols: Int
    let lineWidth: Double
    let inset: Double
    let states: GameOfLife.Grid

    init(
        rows: Int,
        cols: Int,
        lineWidth: Double,
        inset: Double,
        states: GameOfLife.Grid
    ) {
        self.rows = rows
        self.cols = cols
        self.lineWidth = lineWidth
        self.inset = inset
        self.states = states
    }

    func row(for index: Int) -> Int { index / cols }

    func col(for index: Int) -> Int { index % cols  }

    func size(for geo: GeometryProxy) -> CGSize {
        .init(
            width: geo.size.width / Double(cols) - lineWidth - inset,
            height: geo.size.height / Double(rows) - lineWidth - inset
        )
    }

    func color(for index: Int) -> Color {
        states[row(for: index), col(for: index)].color
    }

    func cellState(for index: Int) -> CellState {
        states[row(for: index), col(for: index)]
    }


    func baseCell(
        for geo: GeometryProxy,
        index: Int
    ) -> some View {
        let size = size(for: geo)
        let color = color(for: index)
        return Rectangle()
            .fill(color)
            .background(Image("icons8-plankton")
                .resizable().scaledToFit()
                .opacity(rows < 40 && color == Color("alive") ? 1 : 0)
            )
            .frame(
                width: size.width,
                height: size.height
            )
            .cornerRadius(lineWidth * 3)
            .offset(originOffset(for: index, in: geo))
            .offset(standardInset)
    }

    func shadowedCell(
        for geo: GeometryProxy,
        index: Int
    ) -> some View {
        return baseCell(for: geo, index: index)
            .shadow(
                color: .black,
                radius: inset/2,
                x: inset,
                y: inset
            )
            .shadow(
                color: .black,
                radius: inset/2,
                x: -inset/2,
                y: -inset/2
            )
    }


    func originOffset(for index: Int, in geo: GeometryProxy) -> CGSize {
        .init(
            width: Double(index % cols) * (geo.size.width / Double(cols)),
            height: Double(index / cols) * (geo.size.height / Double(rows))
        )
    }

    var standardInset: CGSize {
        .init(
            width: lineWidth / 2.0 + inset / 2.0,
            height: lineWidth / 2.0 + inset / 2.0
        )
    }

    var body: some View {
        GeometryReader  { geo in
            ForEach(0 ..< (rows * cols), id: \.self) { currentCell in
                cellState(for: currentCell) == .empty
                ? AnyView(baseCell(for: geo, index: currentCell))
                : AnyView(shadowedCell(for: geo, index: currentCell))
            }
            
        }
    }
}

#Preview {
    let rows = 10
    let cols = 10
    return GridCells(
        rows: rows,
        cols: cols,
        lineWidth: 1.0,
        inset: 8.0,
        states: .init(rows, cols, Grid.Initializers.random)
    )
    .aspectRatio(1.0, contentMode: .fit)
}
