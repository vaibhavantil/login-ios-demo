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

// swiftlint:disable line_length
// swiftlint:disable type_name

import Foundation

protocol ModelFactoryProtocol
{
    func createUserProfile(params: UserProfileBuildParams) -> UserProfile
    func createUserCharacter(params: UserCharacterBuildParams) -> UserCharacter
}

class ModelFactory: ModelFactoryProtocol
{
    func createUserProfile(params: UserProfileBuildParams) -> UserProfile
    {
        return UserProfile(dependencies: .init(asyncUtility: UserProfileAsyncUtility(api: self.params.xsollaSDK)))
    }

    func createUserCharacter(params: UserCharacterBuildParams) -> UserCharacter
    {
        let asyncUtility = CharacterAsyncUtility(api: self.params.xsollaSDK,
                                                 projectId: params.projectId,
                                                 userDetailsProvider: params.userDetailsProvider)

        let dependencies = UserCharacter.Dependencies(asyncUtility: asyncUtility,
                                                      loadStateListener: params.loadStateListener,
                                                      customAttributesDataSource: params.customAttributesDataSource,
                                                      readonlyAttributesDataSource: params.readonlyAttributesDataSource)

        return UserCharacter(dependencies: dependencies)
    }

    // MARK: - Initialization
    
    let params: Params
    
    init(params: Params)
    {
        self.params = params
    }
}

extension ModelFactory
{
    struct Params
    {
        let xsollaSDK: XsollaSDKProtocol
        let dataSourceFactory: DatasourceFactoryProtocol
    }
}

struct UserCharacterBuildParams
{
    let projectId: Int
    let userDetailsProvider: UserProfileDetailsProvider
    let loadStateListener: LoadStatable
    let customAttributesDataSource: UserAttributesListDataSource
    let readonlyAttributesDataSource: UserAttributesListDataSource
}

typealias UserProfileBuildParams = EmptyParams
