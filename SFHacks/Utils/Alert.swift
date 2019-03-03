//
//  ErrorAlert.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func createAlertWithoutCancel(alertTitle: String, alertMessage: String, defaultActionTitle: String, defaultActionHandler: @escaping ((UIAlertAction) -> Void)) -> UIAlertController {
        let title = alertTitle
        let message = alertMessage
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: defaultActionTitle, style: UIAlertAction.Style.default, handler: defaultActionHandler)
        ac.addAction(defaultAction)
        return ac
    }
    
    class func createAlert(alertTitle: String, alertMessage: String, rightButtonTitle: String, leftButtonTitle: String, rightButtonAction: @escaping ((UIAlertAction) -> Void), leftButtonAction: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let title = alertTitle
        let message = alertMessage
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let leftButton = UIAlertAction(title: leftButtonTitle, style: UIAlertAction.Style.cancel, handler: leftButtonAction)
        let rightButton = UIAlertAction(title: rightButtonTitle, style: UIAlertAction.Style.default, handler: rightButtonAction)
        ac.addAction(leftButton)
        ac.addAction(rightButton)
        return ac
    }
}


// FIXME: UIAlertControllerは同時に１個しか表示されないので、インスタンス化して管理すべき
// 特に非同期通信で同時に失敗する場合にも一個のAlertしか出ないので、retryのタスクをqueue化する必要あり

func showAlertWithoutCancel(title: String, description: String, rightButtonAction: (() -> Void)? = nil) {
    DispatchQueue.main.async {
        let ac = UIAlertController.createAlertWithoutCancel(
            alertTitle: title,
            alertMessage: description,
            defaultActionTitle: localizedString("alert.general.ok"),
            defaultActionHandler: { _ in
                rightButtonAction?()
        })
        UIApplication.topViewController()?.present(ac, animated: true, completion: nil)
    }
}

func showAlert(title: String = "", description: String = "", rightButtonTitle: String = localizedString("alert.connectionerror.yes"), leftButtonTitle: String = localizedString("alert.connectionerror.no"), rightButtonAction: (() -> Void)? = nil, leftButtonAction: (() -> Void)? = nil) {
    if rightButtonAction == nil && leftButtonAction == nil {
        showAlertWithoutCancel(title: title, description: description)
        return
    }
    
    DispatchQueue.main.async(execute: {
        let ac = UIAlertController.createAlert(
            alertTitle: title,
            alertMessage: description,
            rightButtonTitle: rightButtonTitle,
            leftButtonTitle: leftButtonTitle,
            rightButtonAction:{ _ in
                rightButtonAction?()
        },
            leftButtonAction:{ _ in
                leftButtonAction?()
        })
        UIApplication.topViewController()?.present(ac, animated: true, completion: nil)
    })
}

// deprecated
func showConnectionErrorAlert(vc: UIViewController, title: String = localizedString("alert.connectionerror.title"), retryConnection: (() -> Void)?) {
    showAlert(title: title, description: localizedString("alert.connectionerror.retry"), rightButtonTitle: localizedString("alert.connectionerror.yes"), leftButtonTitle: localizedString("alert.connectionerror.no"), rightButtonAction: retryConnection)
}

class AlertManager {
    // 複数の非同期通信で同時に失敗する場合にも一個のAlertしか出ないので、retryのタスクをqueue化する必要がある
    private class ConnectionErrorAlert {
        private(set) var isShowing: Bool = false
        private let blocksDispatchQueue = DispatchQueue.global()
        private var retryTasks: [(() -> Void)] = [(() -> Void)]()
        
        func addRetryTask(_ retryTask: @escaping (() -> Void)) {
            blocksDispatchQueue.async { [unowned self] in
                self.retryTasks.append(retryTask)
            }
        }
        
        func show() {
            isShowing = true
            showAlertWithoutCancel(
                title: localizedString("alert.connectionerror.title"),
                description: localizedString("alert.connectionerror.retry"),
                rightButtonAction: { [unowned self] in
                    self.blocksDispatchQueue.async { [unowned self] in
                        // needs to be synchronized
                        for retryTask in self.retryTasks {
                            retryTask()
                        }
                        
                        self.retryTasks.removeAll()
                        self.isShowing = false
                    }
            })
        }
    }
    
    static private var connectionErrorAlert: ConnectionErrorAlert = ConnectionErrorAlert()
    
    // use this normally
    class func showConnectionErrorAlert(retryTask: @escaping (() -> Void)) {
        // needs to be synchronized
        connectionErrorAlert.addRetryTask(retryTask)
        if connectionErrorAlert.isShowing == false {
            connectionErrorAlert.show()
        }
    }
    
    class func showConnectionErrorAlertCancellable(retryTask: @escaping (() -> Void), onCancelled: (() -> Void)? = nil) {
        showAlert(
            title: localizedString("alert.connectionerror.title"),
            description: localizedString("alert.connectionerror.retry"),
            rightButtonTitle: localizedString("alert.connectionerror.yes"),
            leftButtonTitle: localizedString("alert.connectionerror.no"),
            rightButtonAction: retryTask,
            leftButtonAction: onCancelled)
    }
    
    class func showConnectionErrorAlertWithMessage(title: String, description: String = "", retryTask: (() -> Void)? = nil) {
        showAlertWithoutCancel(
            title: title,
            description: description,
            rightButtonAction: retryTask)
    }
}
