//
//  AuthenticationController.swift
//  SFHacks
//
//  Created by Shun Sato on 3/2/19.
//  Copyright © 2019 ShunSato. All rights reserved.
//

class AuthenticationController {
    func signUpWithEmail(email: String, password: String, success: @escaping (() -> Void), failure: @escaping (() -> Void)) {
        let request = RequestUsersSignUpEmail(email: email, password: password)
        APIClient.request(request: request).success{ response in
            UserDefaultsManager.save(.accessToken, value: response!.token as Any)
            success()
            }.failure{ error in
                failure()
        }
    }
    
    func signInWithEmail(email: String, password: String, success: @escaping (() -> Void), failure: @escaping (() -> Void)) {
        let request = RequestUsersSignInEmail(email: email, password: password)
        APIClient.request(request: request).success{ response in
            UserDefaultsManager.save(.accessToken, value: response!.token as Any)
            success()
            }.failure{ error in
                failure()
        }
    }
    
    func validateEmail(_ text: String) -> Bool {
        return isEmailValid(text: text)
    }
    
    func validatePassword(_ text: String) -> (succeeded: Bool, error: String) {
        return isPasswordValid(text: text)
    }
}
