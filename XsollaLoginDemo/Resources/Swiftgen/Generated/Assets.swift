// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal static let inactiveMagenta = ColorAsset(name: "inactiveMagenta")
    internal static let inactiveWhite = ColorAsset(name: "inactiveWhite")
    internal static let inputFieldDisabled = ColorAsset(name: "inputFieldDisabled")
    internal static let inputFieldNormal = ColorAsset(name: "inputFieldNormal")
    internal static let darkMagenta = ColorAsset(name: "darkMagenta")
    internal static let magenta = ColorAsset(name: "magenta")
    internal static let black = ColorAsset(name: "black")
    internal static let onSurfaceDisabled = ColorAsset(name: "onSurfaceDisabled")
    internal static let onSurfaceHigh = ColorAsset(name: "onSurfaceHigh")
    internal static let onSurfaceMedium = ColorAsset(name: "onSurfaceMedium")
    internal static let onSurfaceOverlay = ColorAsset(name: "onSurfaceOverlay")
    internal static let transparentMagenta = ColorAsset(name: "transparentMagenta")
    internal static let transparentSlateGrey = ColorAsset(name: "transparentSlateGrey")
    internal static let white = ColorAsset(name: "white")
    internal static let darkSlateBlue = ColorAsset(name: "darkSlateBlue")
    internal static let lightSlateGrey = ColorAsset(name: "lightSlateGrey")
    internal static let nightBlue = ColorAsset(name: "nightBlue")
  }
  internal enum Images {
    internal static let socialBaiduIcon = ImageAsset(name: "social-baidu-icon")
    internal static let socialFacebookIcon = ImageAsset(name: "social-facebook-icon")
    internal static let socialGoogleIcon = ImageAsset(name: "social-google-icon")
    internal static let socialLinkedinIcon = ImageAsset(name: "social-linkedin-icon")
    internal static let socialMoreIcon = ImageAsset(name: "social-more-icon")
    internal static let socialTwitterIcon = ImageAsset(name: "social-twitter-icon")
    internal static let balanceAddIcon = ImageAsset(name: "balance-add-icon")
    internal static let balanceCurrencyIcon = ImageAsset(name: "balance-currency-icon")
    internal static let balanceItemsIcon = ImageAsset(name: "balance-items-icon")
    internal static let menuAccountIcon = ImageAsset(name: "menu-account-icon")
    internal static let menuCharacterIcon = ImageAsset(name: "menu-character-icon")
    internal static let menuFriendsIcon = ImageAsset(name: "menu-friends-icon")
    internal static let menuHelpIcon = ImageAsset(name: "menu-help-icon")
    internal static let menuInventoryIcon = ImageAsset(name: "menu-inventory-icon")
    internal static let menuLogoutIcon = ImageAsset(name: "menu-logout-icon")
    internal static let menuProfileAvatar = ImageAsset(name: "menu-profile-avatar")
    internal static let menuStoreIcon = ImageAsset(name: "menu-store-icon")
    internal static let menuToggleIcon = ImageAsset(name: "menu-toggle-icon")
    internal static let avatarPlaceholderLarge = ImageAsset(name: "avatar-placeholder-large")
    internal static let avatarPlaceholder = ImageAsset(name: "avatar-placeholder")
    internal static let dismissButtonIcon = ImageAsset(name: "dismiss-button-icon")
    internal static let imagePlaceholder = ImageAsset(name: "image-placeholder")
    internal static let textfieldIsSecure = ImageAsset(name: "textfield-is-secure")
    internal static let textfieldNotSecure = ImageAsset(name: "textfield-not-secure")
    internal static let timerIcon = ImageAsset(name: "timer-icon")
    internal static let xsollaLogoWithText = ImageAsset(name: "xsolla-logo-with-text")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = Color(asset: self)

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
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
