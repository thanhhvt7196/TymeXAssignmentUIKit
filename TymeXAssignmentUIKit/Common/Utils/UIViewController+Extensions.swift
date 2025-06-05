//
//  UIViewController+Extensions.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 6/6/25.
//

import UIKit

extension UIViewController {
    func showErrorAlert(title: String = L10n.errorAlertTitle, message: String?, action: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: L10n.okButton, style: .default) { _ in
            action()
        })
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = view
            alertController.popoverPresentationController?.sourceRect = view.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = []
        }
        present(alertController, animated: true)
    }
}
