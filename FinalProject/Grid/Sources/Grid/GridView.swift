//
//  GridView.swift
//  Lecture15
//
//  Created by Van Simmons on 10/24/23.
//

import ComposableArchitecture
import GameOfLife
import SwiftUI

public struct GridView: View {
    var store: StoreOf<GridModel>

    public init(store: StoreOf<GridModel>) {
        self.store = store
    }
    

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { outer in                
                ZStack {
                    GridLines(
                        rows: viewStore.grid.size.rows,
                        cols: viewStore.grid.size.cols,
                        lineWidth: viewStore.lineWidth
                    )
                    .phaseAnimator(
                        [Phase.start, .middle, .end],
                        trigger: viewStore.step
                    ){ content, phase in
                        content
                            .opacity(phase == .start ? 1 : 0.5)
                            .scaleEffect(phase == .middle ? 0 : 1)
                            .rotationEffect(.degrees(phase == .middle ? -180 : 0.0 ))
                    }
                    
                    
                    GridCells(
                        rows: viewStore.grid.size.rows,
                        cols: viewStore.grid.size.cols,
                        lineWidth: viewStore.lineWidth,
                        inset: viewStore.inset,
                        states: viewStore.grid
                        // trigger: viewStore.step
                    )
                    .phaseAnimator(
                        [Phase.start, .end, .middle, .end],
                        trigger: viewStore.step
                    ){ content, phase in
                        content
                            .opacity(phase == .start ? 1 : 0.5)
                            .scaleEffect(phase == .middle ? 0 : 1)
                            .rotationEffect(.degrees(phase == .middle ? 360 : 0.0 ))
                    } animation: { phase in
                        switch phase {
                            case .start: .bouncy(duration: 0.5)
                            case .middle: .linear(duration: 0.3)
                        case .end: .easeInOut(duration: 1.0)
                        }
                    }
                    
    
                    GridTouchView(
                        viewStore: viewStore
                    )


                        Image(viewStore.grid == viewStore.grid.next ?
                              "icons8-spongebob" : "icons8-plankton")
                        .phaseAnimator(
                            [Phase.start, .middle, .end, .middle, .end, .start],
                            trigger: viewStore.resetempty
                        ){ content, phase in
                                content
                                .opacity(phase == .start ? 0 : 1)
                                    .scaleEffect(phase == .start ? 0 : 3)
                                    .rotationEffect(.degrees(phase.shakeAngle))
                            }
                }
            }
            .aspectRatio(1.0, contentMode: .fit)
            .background(Color("gridBackground").opacity(0.5))
            .padding(viewStore.lineWidth / 2.0)
            .clipped()
            .padding(4.0)
            .padding(20.0)
            .phaseAnimator([Phase.start, .end], trigger: viewStore.step){
                $0.opacity( $1 == .start ? 1 : 0)
            }
        }
    }
}

#Preview {
    let rows = 5
    let cols = 5
    let lineWidth = 16.0
    let inset = 8.0

    return GridView(
        store: .init(
            initialState: .init(
                lineWidth: lineWidth,
                inset: inset,
                grid: .init(rows, cols, Grid.Initializers.random)
            ),
            reducer: GridModel.init
        )
    )
}
