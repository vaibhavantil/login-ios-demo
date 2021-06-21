# Xsolla Login demo app for iOS

This demo shows how to implement login and friend systems based on [Xsolla Login](https://developers.xsolla.com/doc/login/) into an iOS application.

The demo covers this list of scenarios:



*   User sign-up via username and password
*   Email confirmation
*   Password reset
*   User authentication via the following social networks:
    *   Google
    *   Facebook
    *   Twitter
    *   LinkedIn
    *   Baidu

<img src="https://i.imgur.com/P5P4fzd.png" alt="Demo Login page" width="250"/>
<img src="https://i.imgur.com/GGiYqAb.png" alt="Demo Sign up page" width="250"/>

The demo also shows these following user management features:



*   User accounts management
*   User attributes customization
*   User account system
*   Friend system

<img src="https://i.imgur.com/aY4DTpK.png" alt="Demo attributes page" width="250"/>
<img src="https://i.imgur.com/momD23N.png" alt="DDemo User Account page" width="250"/>


To try the demo, just build and run this project in Xcode.

<div style="background-color: #d9d9d9">
	<p><b>Note:</b> The demo requires iOS 11.4 or higher.</p>
</div>

All features presented in this demo are based on [Xsolla Login library](https://developers.xsolla.com/sdk/ios/login/) for iOS.

You can use snippets from the demo and library methods to implement your own login and friend systems.

Below are examples of using the basic library methods.


### Receive access token by username and password


```swift
LoginKit.shared.authByUsernameAndPasswordJWT(username: "username",
                                             password: "password",
                                             clientId: AppConfig.loginClientId,
                                             scope: "offline")
{ [weak self] result in
    switch result
    {
        case .success(let accessTokenInfo):
            self?.store(accessTokenInfo)


        case .failure(let error):
            self?.processError(error)
    }
}
```



### Authenticate user via social network


```swift
let oAuth2Params = OAuth2Params(clientId: AppConfig.loginClientId,
                                state: UUID().uuidString,
                                scope: "offline",
                                redirectUri: AppConfig.redirectURL)
LoginKit.shared.getLinkForSocialAuth(providerName: "discord", oauth2params: oAuth2Params)
{ [weak self] result in
    switch result
    {
        case .success(let socialNetworkAuthURL): self?.processSocialNetworkAuthURL(socialNetworkAuthURL)
        case .failure(let error): self?.processError(error)
    }
}
```



### Generate JWT


```swift
LoginKit.shared.generateJWT(grantType: .refreshToken,
                            clientId: AppConfig.loginClientId,
                            refreshToken: resfreshToken,
                            clientSecret: nil,
                            redirectUri: AppConfig.redirectURL,
                            authCode: nil)
{ [weak self] result in
    switch result
    {
        case .success(let accessTokenInfo):
            self?.store(accessTokenInfo)


        case .failure(let error):
            self?.processError(error)
    }
}
```



### Register new user


```swift
let oAuth2Params = OAuth2Params(clientId: AppConfig.loginClientId,
                                state: UUID().uuidString,
                                scope: "offline",
                                redirectUri: AppConfig.redirectURL)
LoginKit.shared.registerNewUser(oAuth2Params: oAuth2Params,
                                username: "username",
                                password: "password",
                                email: "email",
                                acceptConsent: nil,
                                fields: nil,
                                promoEmailAgreement: nil)
{ [weak self] result in
    switch result
    {
        case .success(let urlWithAuthCode):
            self?.handleUrlWithAuthCode(urlWithAuthCode)


        case .failure(let error):
            self?.processError(error)
    }
}
```



### Reset password


```swift
LoginKit.shared.resetPassword(loginProjectId: AppConfig.loginProjectID,
                              username: "username",
                              loginUrl: AppConfig.redirectURL)
{ [weak self] result in
    switch result
    {
        case .success: break
        case .failure(let error): self?.processError(error)
    }
}
```



### Get details of current authenticated user


```swift
LoginKit.shared.getCurrentUserDetails(accessToken: currentAccessToken)
{ [weak self] result in
    switch result
    {
        case .success(let userDetails): self?.processUserDetails(userDetails)
        case .failure(let error): self?.processError(error)
    }
}
```



### Upload user avatar


```swift
LoginKit.shared.uploadUserPicture(accessToken: currentAccessToken, imageURL: imageURL)
{ [weak self] result in
    switch result
    {
        case .success(let uploadedImageURL): break
        case .failure(let error): self?.processError(error)
    }
}
```



## Community

Join our [Discord server](https://discord.gg/auNFyzZx96). Connect with the Xsolla team and developers who use Xsolla products.


## License

See the [LICENSE](https://github.com/xsolla/login-ios-demo/blob/master/LICENSE) file.


## Additional resources

*   [Developers documentation](https://developers.xsolla.com/sdk/ios/)
*   [API reference](https://developers.xsolla.com/login-api/)
*   [Xsolla official website](https://xsolla.com/)
