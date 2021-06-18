// Copyright 2021-present Xsolla (USA), Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at q
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing and permissions and

import UIKit

extension AppCoordinator
{
    static func build(for window: UIWindow) -> AppCoordinator
    {
        let stateProvider = AppStateProvider(params: .init(loginInfoProvider: LoginManager.shared))
        
        let coordinatorDependencies = AppCoordinator.Dependencies(factories: projectFactories,
                                                                  appstateProvider: stateProvider,
                                                                  loginManager: LoginManager.shared)
        
        let coordinator = AppCoordinator(window: window, dependencies: coordinatorDependencies, params: .none)
        
        return coordinator
    }
    
    private static var projectFactories: Factories =
    {
        let viewControllerFactory = ViewControllerFactory(params: .none)
        let datasourceFactory = DatasourceFactory(params: .none)
        
        let xsollaSDK = XsollaSDK(accessTokenProvider: LoginManager.shared)
        xsollaSDK.authorizationErrorDelegate = LoginManager.shared
        
        let modelFactory = ModelFactory(params: .init(xsollaSDK: xsollaSDK, dataSourceFactory: datasourceFactory))
        
        let coordinatorFactoryParams = CoordinatorFactory.Params(viewControllerFactory: viewControllerFactory,
                                                                 datasourceFactory: datasourceFactory,
                                                                 modelFactory: modelFactory,
                                                                 xsollaSDK: xsollaSDK)
        
        let coordinatorFactory = CoordinatorFactory(params: coordinatorFactoryParams)
        
        let factories = Factories(coordinatorFactory: coordinatorFactory,
                                  viewControllerFactory: viewControllerFactory,
                                  datasourceFactory: datasourceFactory,
                                  modelFactoryProtocol: modelFactory)
        
        return factories
    }()
}
