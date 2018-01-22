//
//  Copyright © 2017 Carmen Cerino. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertAction {
    
    /**
     Creates a `UIAlertAction` for the common case of canceling a `UIAlertController`.
     
     - Parameter handler: An optional handler called when the user selects this action.
     
     - Returns: A new `UIAlertAction`.
     */
    public static func cancelAction(_ handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: handler)
    }

    /**
     Creates a `UIAlertAction` for the common case of an 'Ok' button.
     
     - Parameter handler: An optional handler called when the user selects this action.
     
     - Returns: A new `UIAlertAction`.
     */
    public static func okayAction(_ handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: handler)
    }

    /**
     Creates a `UIAlertAction` for opening the applications settings in the Settings application.
     
     - Parameter handler: An optional handler called before the settings app is launched.
     
     - Returns: A new `UIAlertAction`.
     */
    public static func openSettingsAction(_ handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: NSLocalizedString("Open Settings", comment: "Open Settings"), style: .default) { (action) in
            handler?(action)
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}
