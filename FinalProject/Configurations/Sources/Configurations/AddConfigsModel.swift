//
//  AddConfigsModel.swift
//
//
import Combine
import ComposableArchitecture
import GameOfLife

@Reducer
public struct AddConfigModel {
    public struct State: Equatable, Codable {
        public var title: String
        public var counterState: CounterModel.State

        public init(title: String = "", counterState: CounterModel.State = CounterModel.State()) {
            self.title = title
            self.counterState = counterState
        }
    }

    public enum Action: Equatable {
        case updateTitle(String)
        case counter(action: CounterModel.Action)
        case cancel
        case ok(GameOfLife.Grid.Configuration)
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Scope(
            state: \.counterState,
            action: /AddConfigModel.Action.counter(action:),
            child: CounterModel.init
        )

        Reduce { state, action in
            switch action {
                case .updateTitle(let title):
                    state.title = title
                    return .none
                case .cancel:
                    return .none
                case .ok:
                    return .none
                case .counter:
                    return .none
            }
        }
    }
}
