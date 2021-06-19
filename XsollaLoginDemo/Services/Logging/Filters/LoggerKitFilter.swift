// XSOLLA_SDK_LICENCE_HEADER_PLACEHOLDER

import Foundation
import XsollaSDKUtilities

// swiftlint:disable type_name

class LoggerKitFilter: LoggerKitDefaultFilter
{
    override init()
    {
        super.init()
        
        excludingLevels = []
        excludingCategories = [LogCategory.initialization, LogCategory.deinitialization]
        excludingDomains = []
        
        fileSearchIncludeString = ""
        fileSearchExcludeString = ""
        methodSearchIncludeString = ""
        methodSearchExcludeString = ""
    }
}
