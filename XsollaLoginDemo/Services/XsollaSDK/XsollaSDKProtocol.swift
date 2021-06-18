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

// swiftlint:disable function_parameter_count

import Foundation
import XsollaSDKLoginKit

protocol XsollaSDKProtocol
{
    // MARK: - LoginKit
    
    func authByUsernameAndPassword(username: String,
                                   password: String,
                                   oAuth2Params: OAuth2Params,
                                   completion: @escaping LoginKitCompletion<String>)
    
    func authByUsernameAndPasswordJWT(username: String,
                                      password: String,
                                      clientId: Int,
                                      scope: String?,
                                      completion: ((Result<AccessTokenInfo, Error>) -> Void)?)
    
    func getLinkForSocialAuth(providerName: String,
                              oauth2params: OAuth2Params,
                              completion: @escaping LoginKitCompletion<URL>)
    
    func authBySocialNetwork(oAuth2Params: OAuth2Params,
                             providerName: String,
                             socialNetworkAccessToken: String,
                             socialNetworkAccessTokenSecret: String?,
                             socialNetworkOpenId: String?,
                             completion: @escaping LoginKitCompletion<String>)
    
    func generateJWT(grantType: TokenGrantType,
                     clientId: Int,
                     refreshToken: String?,
                     clientSecret: String?,
                     redirectUri: String?,
                     authCode: String?,
                     completion: ((Result<AccessTokenInfo, Error>) -> Void)?)
    
    func registerNewUser(oAuth2Params: OAuth2Params,
                         username: String,
                         password: String,
                         email: String,
                         acceptConsent: Bool?,
                         fields: [String: String]?,
                         promoEmailAgreement: Int?,
                         completion: ((Result<URL?, Error>) -> Void)?)
    
    func resetPassword(loginProjectId: String,
                       username: String,
                       loginUrl: String?,
                       completion: ((Result<Void, Error>) -> Void)?)
    
    func getCurrentUserDetails(completion: ((Result<UserProfileDetails, Error>) -> Void)?)
    
    func updateCurrentUserDetails(birthday: Date?,
                                  firstName: String?,
                                  lastName: String?,
                                  nickname: String?,
                                  gender: UserProfileDetails.Gender?,
                                  completion: ((Result<UserProfileDetails, Error>) -> Void)?)
    
    func getUserEmail(completion: ((Result<String?, Error>) -> Void)?)
    
    func deleteUserPicture(completion: ((Result<Void, Error>) -> Void)?)
    
    func uploadUserPicture(imageURL: URL, completion: ((Result<String, Error>) -> Void)?)
    
    func getCurrentUserPhone(completion: ((Result<String?, Error>) -> Void)?)
    
    func updateCurrentUserPhone(phoneNumber: String, completion: ((Result<Void, Error>) -> Void)?)
    
    func deleteCurrentUserPhone(phoneNumber: String, completion: ((Result<Void, Error>) -> Void)?)
    
    func getCurrentUserFriends(listType: FriendsListType,
                               sortType: FriendsListSortType,
                               sortOrderType: FriendsListOrderType,
                               after: String?,
                               limit: Int?,
                               completion: ((Result<FriendsList, Error>) -> Void)?)
    
    func updateCurrentUserFriends(actionType: FriendsListUpdateAction,
                                  userID: String,
                                  completion: ((Result<Void, Error>) -> Void)?)
    
    func getLinkedNetworks(completion: ((Result<[UserSocialNetworkInfo], Error>) -> Void)?)
    
    func getURLToLinkSocialNetworkToAccount(providerName: String,
                                            loginURL: String,
                                            completion: ((Result<String, Error>) -> Void)?)
    
    func startSocialNetworkLinking(toProvider providerName: String,
                                   loginURL: String,
                                   presenter: Presenter,
                                   completion: ((Result<Void, Error>) -> Void)?)
    
    func getClientUserAttributes(keys: [String]?,
                                 publisherProjectId: Int?,
                                 userId: String?,
                                 completion: ((Result<[UserAttribute], Error>) -> Void)?)
    
    func getClientUserReadOnlyAttributes(keys: [String]?,
                                         publisherProjectId: Int?,
                                         userId: String?,
                                         completion: ((Result<[UserAttribute], Error>) -> Void)?)
    
    func updateClientUserAttributes(attributes: [UserAttribute]?,
                                    publisherProjectId: Int?,
                                    removingKeys: [String]?,
                                    completion: ((Result<Void, Error>) -> Void)?)
}
