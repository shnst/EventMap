//
//  EntranceViewController.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

import UIKit
import SVProgressHUD


class EntranceViewController: UIViewController {
    
    private var controller = AuthenticationController()
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
    }
    
    //start of signIn
    
    private func signIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        guard controller.validateEmail(email) else {
            p("invalid email")
            showAlertWithoutCancel(title: "Invalid e-mail format.", description: "")
            return
        }
        let validationResult = controller.validatePassword(password)
        guard validationResult.succeeded else {
            p("invalid password")
            showAlertWithoutCancel(title: validationResult.error, description: "")
            return
        }
        
        SVProgressHUD.show()
        controller.signInWithEmail(
            email: email,
            password: password,
            success: {
                SVProgressHUD.dismiss()
                ScreenTransitionManager.moveToMapBrowserViewController()
        },
            failure: { [weak self] in
                SVProgressHUD.dismiss()
                showAlertWithoutCancel(title: "ログインに失敗しました。", description: "")
                //                AlertManager.showConnectionErrorAlertCancellable(retryTask: { [weak self] in
                //                    guard let sself = self else { return }
                //                    sself.signIn()
                //                })
        })
    }
    
    
    //start of Signup
    private func signUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        guard controller.validateEmail(email) else {
            p("invalid email")
            showAlertWithoutCancel(title: "Invalid e-mail format.", description: "")
            return
        }
        let validationResult = controller.validatePassword(password)
        guard validationResult.succeeded else {
            p("invalid password")
            showAlertWithoutCancel(title: validationResult.error, description: "")
            return
        }
        
        SVProgressHUD.show()
        controller.signUpWithEmail(
            email: email,
            password: password,
            success: {
                SVProgressHUD.dismiss()
                ScreenTransitionManager.moveToMapBrowserViewController()
        },
            failure: { [weak self] in
                SVProgressHUD.dismiss()
                AlertManager.showConnectionErrorAlertCancellable(retryTask: { [weak self] in
                    guard let sself = self else { return }
                    sself.signUp()
                })
        })
    }
    
    @IBAction func onSignInButtonTapped(_ sender: UIButton) {
        signIn()
    }
    
    @IBAction func onCreateButtonTapped(_ sender: UIButton) {
        signUp()
    }
    
//    @IBAction func onBackButtonTapped(_ sender: UIButton) {
//        _ = navigationController?.popViewController(animated: true)
//    }
}



