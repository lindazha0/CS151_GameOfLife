//
//  Configuration.swift
//  SwiftUIGameOfLife
//
//  Created by Van Simmons on 5/31/20.
//  Copyright © 2020 ComputeCycles, LLC. All rights reserved.
//
import Foundation
import ComposableArchitecture
import Combine
import Dispatch
import GameOfLife
import Configuration

// MARK: API Support
private let configURL = URL(string: "https://www.dropbox.com/s/i4gp5ih4tfq3bve/S65g.json?dl=1")!

enum APIError: Error {
    case urlError(URL, URLError)
    case badResponse(URL, URLResponse)
    case badResponseStatus(URL, HTTPURLResponse)
    case jsonDecodingError(URL, Error, String)
}

class DefaultHandlingSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        completionHandler(.performDefaultHandling, .none)
    }
}

public struct ConfigurationsModel: Reducer {
    static var session: URLSession {
        URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: DefaultHandlingSessionDelegate(),
            delegateQueue: .none
        )
    }
    
    static func validateHttpResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.badResponse(configURL, response)
        }
        guard httpResponse.statusCode == 200 else {
            throw APIError.badResponseStatus(configURL, httpResponse)
        }
        return data
    }
    
    public struct State: Equatable, Codable {
        public var configs: IdentifiedArrayOf<ConfigurationModel.State> = []
        public var isFetching = false
        public var isAdding = false
        public var addConfigState: AddConfigModel.State
        
        // for animation
        var slider = 0.0
        
        public init(
            configs: IdentifiedArrayOf<ConfigurationModel.State> = [],
            addConfigsState: AddConfigModel.State = .init()
        ) {
            self.configs = configs
            self.addConfigState = addConfigsState
        }
    }
    
    public enum Action {
        case setConfigs([ConfigurationModel.State])
        case add
        case stopAdding(Bool)
        case fetch
        case cancelFetch
        case clear
        case configuration(id: UUID, action: ConfigurationModel.Action)
        case addConfig(action: AddConfigModel.Action)
    }
    
    enum Identifiers: Hashable, CaseIterable {
        case fetchCancellable
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .add:
                    state.isAdding = true
                    return .none
                case .stopAdding:
                    state.isAdding = false
                    return .none
                case .setConfigs(let configs):
                    state.configs = IdentifiedArrayOf(uniqueElements:configs)
                    return .none
                case .fetch:
                    state.isFetching = true
                    state.configs = []
                    return Effect
                        .publisher {URLSession
                            .DataTaskPublisher(request: URLRequest(url: configURL), session: Self.session)
                            .mapError { APIError.urlError(configURL, $0) }
                            .tryMap (Self.validateHttpResponse)
                            .mapError { $0 as! APIError }
                            .decode(type: [Grid.Configuration].self, decoder: JSONDecoder())
                            .replaceError(with: [])
                            .map { configs in
                                Action.setConfigs(
                                    configs.map { config in
                                        ConfigurationModel.State.init(
                                            configuration: config,
                                            style: \GameOfLife.Grid.Configuration.defaultGrid
                                        )
                                    }
                                )
                            }
                            .receive(on: DispatchQueue.main)
                        }
                        .cancellable(id: Identifiers.fetchCancellable)
                case .cancelFetch:
                    state.isFetching = false
                    return .cancel(id: ConfigurationsModel.Identifiers.fetchCancellable)
                case .clear:
                    state.isFetching = false
                    state.configs = []
                    return .cancel(id: ConfigurationsModel.Identifiers.fetchCancellable)
                case  .configuration:
                    return .none
                case .addConfig(action: let addConfigAction):
                    switch addConfigAction {
                        case let .ok(newConfig):
                            state.configs.append(
                                ConfigurationModel.State.init(
                                    configuration: newConfig,
                                    style: \GameOfLife.Grid.Configuration.smallGrid
                                )
                            )
                            state.isAdding = false
                        case .cancel:
                            state.isAdding = false
                        case let .updateTitle(newTitle):
                            state.addConfigState.title = newTitle
                        case let .counter(action: newAction):
                            switch newAction {
                                case .decrementButtonTapped:
                                    state.addConfigState.counterState.count -= 1
                                case .incrementButtonTapped:
                                    state.addConfigState.counterState.count += 1
                            }
                    }
                    return .none
            }
        }
        .forEach(\.configs, action: /ConfigurationsModel.Action.configuration) {
            ConfigurationModel()
        }
    }
}
