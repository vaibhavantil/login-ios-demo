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

// swiftlint:disable opening_braces
// swiftlint:disable closure_end_indentation
// swiftlint:disable function_parameter_count

import Foundation
import XsollaSDKLoginKit

protocol XsollaSDKAuthorizationErrorDelegate: AnyObject
{
    func xsollaSDK(_ xsollaSDK: XsollaSDK, didFailAuthorizationWithError error: Error)
}

final class XsollaSDK
{
    let accessTokenProvider: AccessTokenProvider
    
    weak var authorizationErrorDelegate: XsollaSDKAuthorizationErrorDelegate?
    
    private var login: LoginKit { .shared }
    
    @Atomic private var isTokenDependedTasksInProcess = false
    private var tokenDependentTasksQueue = ThreadSafeArray<TokenDependentTask>()
    
    init(accessTokenProvider: AccessTokenProvider)
    {
        self.accessTokenProvider = accessTokenProvider
    }
    
    private func startTokenDependentTask(_ completion: @escaping (String?) -> Void)
    {
        let task = TokenDependentTask(completion: completion)
        startTokenDependentTask(task)
    }
    
    private func startTokenDependentTask(_ task: TokenDependentTask)
    {
        tokenDependentTasksQueue.append(task)
        
        guard !isTokenDependedTasksInProcess else { return }
        isTokenDependedTasksInProcess = true
        
        accessTokenProvider.getAccessToken
        { [weak self] result in
            
            switch result
            {
                case .success(let token): self?.processTokenDependedTasksQueue(withToken: token)
                case .failure: self?.invalidateQueue()
            }
            
            self?.isTokenDependedTasksInProcess = false
        }
    }
    
    private func processTokenDependedTasksQueue(withToken token: String)
    {
        while tokenDependentTasksQueue.count > 0
        {
            tokenDependentTasksQueue.first?.completion(token)
            tokenDependentTasksQueue.dropFirst()
        }
    }
    
    private func invalidateQueue()
    {
        while tokenDependentTasksQueue.count > 0
        {
            tokenDependentTasksQueue.first?.completion(nil)
            tokenDependentTasksQueue.dropFirst()
        }
    }
}

// MARK: - Login API

extension XsollaSDK: XsollaSDKProtocol
{
    func authByUsernameAndPassword(username: String,
                                   password: String,
                                   oAuth2Params: OAuth2Params,
                                   completion: @escaping LoginKitCompletion<String>)
    {
        login.authByUsernameAndPassword(username: username,
                                        password: password,
                                        oAuth2Params: oAuth2Params,
                                        completion: completion)
    }
    
    func authByUsernameAndPasswordJWT(username: String,
                                      password: String,
                                      clientId: Int,
                                      scope: String?,
                                      completion: ((Result<AccessTokenInfo, Error>) -> Void)?)
    {
        login.authByUsernameAndPasswordJWT(username: username,
                                           password: password,
                                           clientId: clientId,
                                           scope: scope)
        { [weak self] result in
            switch result
            {
                case .success(let tokenInfo): do
                {
                    completion?(.success(tokenInfo))
                }
                
                case .failure(let error): do
                {
                    self?.processError(error)
                    completion?(.failure(error))
                }
            }
        }
    }
    
    func getLinkForSocialAuth(providerName: String,
                              oauth2params: OAuth2Params,
                              completion: @escaping LoginKitCompletion<URL>)
    {
        login.getLinkForSocialAuth(providerName: providerName, oauth2params: oauth2params, completion: completion)
    }
    
    func authBySocialNetwork(oAuth2Params: OAuth2Params,
                             providerName: String,
                             socialNetworkAccessToken: String,
                             socialNetworkAccessTokenSecret: String?,
                             socialNetworkOpenId: String?,
                             completion: @escaping LoginKitCompletion<String>)
    {
        login.authBySocialNetwork(oAuth2Params: oAuth2Params,
                                  providerName: providerName,
                                  socialNetworkAccessToken: socialNetworkAccessToken,
                                  socialNetworkAccessTokenSecret: socialNetworkAccessTokenSecret,
                                  socialNetworkOpenId: socialNetworkOpenId,
                                  completion: completion)
    }
    
    func generateJWT(grantType: TokenGrantType,
                     clientId: Int,
                     refreshToken: String?,
                     clientSecret: String?,
                     redirectUri: String?,
                     authCode: String?,
                     completion: ((Result<AccessTokenInfo, Error>) -> Void)?)
    {
        login.generateJWT(grantType: grantType,
                          clientId: clientId,
                          refreshToken: refreshToken,
                          clientSecret: clientSecret,
                          redirectUri: redirectUri,
                          authCode: authCode)
        { [weak self] result in
            switch result
            {
                case .success(let tokenInfo): do
                {
                    completion?(.success(tokenInfo))
                }
                
                case .failure(let error): do
                {
                    self?.processError(error)
                    completion?(.failure(error))
                }
            }
        }
    }
    
    func registerNewUser(oAuth2Params: OAuth2Params,
                         username: String,
                         password: String,
                         email: String,
                         acceptConsent: Bool?,
                         fields: [String: String]?,
                         promoEmailAgreement: Int?,
                         completion: ((Result<URL?, Error>) -> Void)?)
    {
        login.registerNewUser(oAuth2Params: oAuth2Params,
                              username: username,
                              password: password,
                              email: email,
                              acceptConsent: acceptConsent,
                              fields: fields,
                              promoEmailAgreement: promoEmailAgreement)
        { [weak self] result in
            switch result
            {
                case .success(let url): completion?(.success(url))
                case .failure(let error): do
                {
                    self?.processError(error)
                    completion?(.failure(error))
                }
            }
        }
    }
    
    func resetPassword(loginProjectId: String,
                       username: String,
                       loginUrl: String?,
                       completion: ((Result<Void, Error>) -> Void)?)
    {
        login.resetPassword(loginProjectId: loginProjectId,
                            username: username,
                            loginUrl: loginUrl)
        { [weak self] result in
            switch result
            {
                case .success: completion?(.success(()))
                case .failure(let error): do
                {
                    self?.processError(error)
                    completion?(.failure(error))
                }
            }
        }
    }
    
    func getCurrentUserDetails(completion: ((Result<UserProfileDetails, Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.getCurrentUserDetails(accessToken: token)
            { result in
                
                switch result
                {
                    case .success(let userDetails): do
                    {
                        completion?(.success(userDetails))
                    }
                        
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func updateCurrentUserDetails(birthday: Date?,
                                  firstName: String?,
                                  lastName: String?,
                                  nickname: String?,
                                  gender: UserProfileDetails.Gender?,
                                  completion: ((Result<UserProfileDetails, Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.updateCurrentUserDetails(accessToken: token,
                                                 birthday: birthday,
                                                 firstName: firstName,
                                                 lastName: lastName,
                                                 nickname: nickname,
                                                 gender: gender)
            { result in
                
                switch result
                {
                    case .success(let userDetails): do
                    {
                        completion?(.success(userDetails))
                    }
                        
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func getUserEmail(completion: ((Result<String?, Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.getUserEmail(accessToken: token)
            { result in
                
                switch result
                {
                    case .success(let email): completion?(.success(email))
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func deleteUserPicture(completion: ((Result<Void, Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.deleteUserPicture(accessToken: token)
            { result in
                
                switch result
                {
                    case .success: completion?(.success(()))
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func uploadUserPicture(imageURL: URL, completion: ((Result<String, Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.uploadUserPicture(accessToken: token, imageURL: imageURL)
            { result in
                
                switch result
                {
                    case .success(let urlString): completion?(.success(urlString))
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func getCurrentUserPhone(completion: ((Result<String?, Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.getCurrentUserPhone(accessToken: token)
            { result in
                
                switch result
                {
                    case .success(let phone): completion?(.success(phone))
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func updateCurrentUserPhone(phoneNumber: String, completion: ((Result<Void, Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.updateCurrentUserPhone(accessToken: token, phoneNumber: phoneNumber)
            { result in
                
                switch result
                {
                    case .success: completion?(.success(()))
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func deleteCurrentUserPhone(phoneNumber: String, completion: ((Result<Void, Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.deleteCurrentUserPhone(accessToken: token, phoneNumber: phoneNumber)
            { result in
                
                switch result
                {
                    case .success: completion?(.success(()))
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func getCurrentUserFriends(listType: FriendsListType,
                               sortType: FriendsListSortType,
                               sortOrderType: FriendsListOrderType,
                               after: String?,
                               limit: Int?,
                               completion: ((Result<FriendsList, Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.getCurrentUserFriends(accessToken: token,
                                              listType: listType,
                                              sortType: sortType,
                                              sortOrderType: sortOrderType,
                                              after: after,
                                              limit: limit)
            { result in
                
                switch result
                {
                    case .success(let friendsList): completion?(.success(friendsList))
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func updateCurrentUserFriends(actionType: FriendsListUpdateAction,
                                  userID: String,
                                  completion: ((Result<Void, Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.updateCurrentUserFriends(accessToken: token, actionType: actionType, userID: userID)
            { result in
                
                switch result
                {
                    case .success: completion?(.success(()))
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func getLinkedNetworks(completion: ((Result<[UserSocialNetworkInfo], Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.getLinkedNetworks(accessToken: token)
            { result in
                
                switch result
                {
                    case .success(let userSocialNetworks): completion?(.success(userSocialNetworks))
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func getURLToLinkSocialNetworkToAccount(providerName: String,
                                            loginURL: String,
                                            completion: ((Result<String, Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.getURLToLinkSocialNetworkToAccount(accessToken: token,
                                                           providerName: providerName,
                                                           loginURL: loginURL)
            { result in
                
                switch result
                {
                    case .success(let urlString): completion?(.success(urlString))
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func startSocialNetworkLinking(toProvider providerName: String,
                                   loginURL: String,
                                   presenter: Presenter,
                                   completion: ((Result<Void, Error>) -> Void)?)
    {
        startTokenDependentTask
        { token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            let viewController = SocialNetworkLinkingVC()
            presenter.present(viewController, animated: true, completion: nil)
            
            viewController.startLinking(toProvider: providerName, withAccessToken: token, loginURL: loginURL)
            { (result, vc) in
                vc.dismiss(animated: true, completion: nil)
                completion?(result)
            }
        }
    }
    
    func getClientUserAttributes(keys: [String]?,
                                 publisherProjectId: Int?,
                                 userId: String?,
                                 completion: ((Result<[UserAttribute], Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.getClientUserAttributes(accessToken: token,
                                                keys: keys,
                                                publisherProjectId: publisherProjectId,
                                                userId: userId)
            { result in
                
                switch result
                {
                    case .success(let userAttributes): completion?(.success(userAttributes))
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func getClientUserReadOnlyAttributes(keys: [String]?,
                                         publisherProjectId: Int?,
                                         userId: String?,
                                         completion: ((Result<[UserAttribute], Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.getClientUserReadOnlyAttributes(accessToken: token,
                                                        keys: keys,
                                                        publisherProjectId: publisherProjectId,
                                                        userId: userId)
            { result in
                
                switch result
                {
                    case .success(let userAttributes): completion?(.success(userAttributes))
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func updateClientUserAttributes(attributes: [UserAttribute]?,
                                    publisherProjectId: Int?,
                                    removingKeys: [String]?,
                                    completion: ((Result<Void, Error>) -> Void)?)
    {
        startTokenDependentTask
        { [weak self] token in
            guard let token = token else { completion?(.failure(LoginKitError.invalidToken)); return }
            
            self?.login.updateClientUserAttributes(accessToken: token,
                                                   attributes: attributes,
                                                   publisherProjectId: publisherProjectId,
                                                   removingKeys: removingKeys)
            { result in
                
                switch result
                {
                    case .success: completion?(.success(()))
                    case .failure(let error): do
                    {
                        self?.processError(error)
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
}

// MARK: - Helpers

extension XsollaSDK
{
    private func processError(_ error: Error)
    {
        switch error
        {
            case LoginKitError.invalidToken:
                authorizationErrorDelegate?.xsollaSDK(self, didFailAuthorizationWithError: error)
            
            default: break
        }
    }
}

extension XsollaSDK
{
    struct TokenDependentTask
    {
        let completion: (String?) -> Void
    }
}
