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
import XsollaSDKLoginKit

protocol DatasourceFactoryProtocol
{
    func createUserAttributesListDataSource(params: UserAttributesListDataSourceBuildParams) -> UserAttributesListDataSource
}

class DatasourceFactory: DatasourceFactoryProtocol
{
    func createUserAttributesListDataSource(params: UserAttributesListDataSourceBuildParams) -> UserAttributesListDataSource
    {
        switch params.type
        {
            case .custom: return CustomUserAttributesListDataSource(title: L10n.Character.TabBar.customAttributes,
                                                                    actionHandler: params.actionHandler)

            case .readonly: return ReadonlyUserAttributesListDataSource(title: L10n.Character.TabBar.customAttributes,
                                                                        actionHandler: params.actionHandler)
        }
    }
    
    // MARK: - Initialization
    
    let params: Params
    
    init(params: Params)
    {
        self.params = params
    }
}

extension DatasourceFactory
{
    struct Params
    {
        static let none = Params()
    }
}

struct UserAttributesListDataSourceBuildParams
{
    let type: AttributeType
    let actionHandler: UserAttributesListDataSource.ActionHandler

    enum AttributeType
    {
        case custom
        case readonly
    }

    static func custom(actionHandler: @escaping UserAttributesListDataSource.ActionHandler) -> Self
    {
        Self(type: .custom, actionHandler: actionHandler)
    }

    static func readonly(actionHandler: @escaping UserAttributesListDataSource.ActionHandler) -> Self
    {
        Self(type: .readonly, actionHandler: actionHandler)
    }
}
