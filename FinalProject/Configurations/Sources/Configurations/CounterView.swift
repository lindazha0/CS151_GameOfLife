//
//  CounterView.swift
//  FinalProject
//
import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    let store: StoreOf<CounterModel>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                Button("−") { viewStore.send(.decrementButtonTapped) }
                Text("\(viewStore.count)")
                    .font(Font.title.monospacedDigit())
                Button("+") { viewStore.send(.incrementButtonTapped) }
            }
        }
    }
}

#Preview {
    CounterView(
        store: StoreOf<CounterModel>(
            initialState: .init(count: 10),
            reducer: CounterModel.init
        )
    )
}
