// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length implicit_return

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Authentication: StoryboardType {
    internal static let storyboardName = "Authentication"

    internal static let login = SceneType<XsollaLoginDemo.LoginVC>(storyboard: Authentication.self, identifier: "Login")

    internal static let main = SceneType<XsollaLoginDemo.AuthenticationMainVC>(storyboard: Authentication.self, identifier: "Main")

    internal static let recoverPassword = SceneType<XsollaLoginDemo.RecoverPasswordVC>(storyboard: Authentication.self, identifier: "RecoverPassword")

    internal static let signup = SceneType<XsollaLoginDemo.SignupVC>(storyboard: Authentication.self, identifier: "Signup")
  }
  internal enum Character: StoryboardType {
    internal static let storyboardName = "Character"

    internal static let attributeEditor = SceneType<XsollaLoginDemo.AttributeEditorVC>(storyboard: Character.self, identifier: "AttributeEditor")

    internal static let character = SceneType<XsollaLoginDemo.CharacterVC>(storyboard: Character.self, identifier: "Character")
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let main = SceneType<XsollaLoginDemo.MainVC>(storyboard: Main.self, identifier: "Main")
  }
  internal enum SideMenu: StoryboardType {
    internal static let storyboardName = "SideMenu"

    internal static let sideMenu = SceneType<XsollaLoginDemo.SideMenuVC>(storyboard: SideMenu.self, identifier: "SideMenu")

    internal static let sideMenuContent = SceneType<XsollaLoginDemo.SideMenuContentVC>(storyboard: SideMenu.self, identifier: "SideMenuContent")
  }
  internal enum UserProfile: StoryboardType {
    internal static let storyboardName = "UserProfile"

    internal static let userProfile = SceneType<XsollaLoginDemo.UserProfileVC>(storyboard: UserProfile.self, identifier: "UserProfile")

    internal static let userProfileAvatarSelector = SceneType<XsollaLoginDemo.UserProfileAvatarSelectorVC>(storyboard: UserProfile.self, identifier: "UserProfileAvatarSelector")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: BundleToken.bundle)
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    return storyboard.storyboard.instantiateViewController(identifier: identifier, creator: block)
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }

  @available(iOS 13.0, tvOS 13.0, *)
  internal func instantiate(creator block: @escaping (NSCoder) -> T?) -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController(creator: block) else {
      fatalError("Storyboard \(storyboard.storyboardName) does not have an initial scene.")
    }
    return controller
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
