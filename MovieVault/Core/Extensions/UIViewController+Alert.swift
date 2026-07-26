//
//  UIViewController+Alert.swift
//  MovieVault
//
//  Created by Faruk on 17.07.2026.
//

import UIKit

@MainActor
extension UIViewController {

    func showAlert(
        title: String = "Error",
        message: String,
        retryTitle: String = "Retry",
        cancelTitle: String = "Cancel",
        retryAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        if let retryAction {
            alert.addAction(
                UIAlertAction(title: retryTitle, style: .default) { _ in
                    retryAction()
                }
            )

            alert.addAction(
                UIAlertAction(title: cancelTitle, style: .cancel)
            )
        } else {
            alert.addAction(
                UIAlertAction(title: "OK", style: .default)
            )
        }

        present(alert, animated: true)
    }
}
