//
//  CounterModel.swift
//  
//
import ComposableArchitecture

@Reducer
public struct CounterModel {
    public struct State: Equatable, Codable {
        public var count: Int
        public init(count: Int = 10) {
            self.count = count
        }
    }

    public enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
    }

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .decrementButtonTapped:
                    state.count -= 1
                    return .none
                case .incrementButtonTapped:
                    state.count += 1
                    return .none
            }
        }
    }
}
