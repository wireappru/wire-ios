//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Foundation

extension UIAlertController {

    /// flag for preventing newsletter subscription dialog shows again in team creation workflow.
    /// (team create work flow: newsletter subscription dialog appears after email verification.
    /// email regisration work flow: newsletter subscription dialog appears after conversation list is displayed.)
    static var newsletterSubscriptionDialogWasDisplayed = false

    static func showNewsletterSubscriptionDialog(completionHandler: @escaping (Bool) -> Void) {
        guard !AutomationHelper.sharedHelper.skipFirstLoginAlerts else { return }

        let alertController = UIAlertController(title: "news_offers.consent.title".localized,
                                                message: "news_offers.consent.message".localized,
                                                preferredStyle: .alert)

        let privacyPolicyActionHandler: ((UIAlertAction) -> Swift.Void) = { _ in
            if let browserViewController = BrowserViewController(url: (NSURL.wr_privacyPolicy() as NSURL).wr_URLByAppendingLocaleParameter() as URL) {
                browserViewController.completion = { _ in
                    UIAlertController.showNewsletterSubscriptionDialog(completionHandler: completionHandler)
                }

                AppDelegate.shared().notificationsWindow?.rootViewController?.present(browserViewController, animated: true)
            }
        }

        alertController.addAction(UIAlertAction(title: "news_offers.consent.button.privacy_policy.title".localized,
                                                style: .default,
                                                handler: privacyPolicyActionHandler))

        alertController.addAction(UIAlertAction(title: "general.skip".localized,
                                                style: .default,
                                                handler: { (_) in
                                                    completionHandler(false)
        }))

        alertController.addAction(UIAlertAction(title: "general.accept".localized,
                                                style: .cancel,
                                                handler: { (_) in
                                                    completionHandler(true)
        }))

        UIAlertController.newsletterSubscriptionDialogWasDisplayed = true
        AppDelegate.shared().notificationsWindow?.rootViewController?.present(alertController, animated: true) {
            UIApplication.shared.keyWindow?.endEditing(true)
        }
    }

    static func showNewsletterSubscriptionDialogIfNeeded(completionHandler: @escaping (Bool) -> Void) {
        guard !UIAlertController.newsletterSubscriptionDialogWasDisplayed else { return }

        showNewsletterSubscriptionDialog(completionHandler: completionHandler)
    }
}
