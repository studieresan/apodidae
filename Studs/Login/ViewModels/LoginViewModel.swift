//
//  LoginViewModel.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-23.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation
import RxSwift

final class LoginViewModel {

    // MARK: Properties

    private var errorMsg = "" {
        didSet {
            self.onErrorMsgChange?(self.errorMsg)
        }
    }

    private var isLoggedIn = false {
        didSet {
            self.onLoginChange?(self.isLoggedIn)
        }
    }

    private let disposeBag = DisposeBag()

    // What should happen when the errorMsg is changed
    var onErrorMsgChange: ((String) -> Void)?

    // What should happen when the login status changes
    var onLoginChange: ((Bool) -> Void)?

    // MARK: Public methods

    func login(email: String, password: String) {
        if !isValidEmail(string: email) {
            errorMsg = "Please log in with a valid email"
            return
        }

        // Fetch the events
        Http.login(email: email, password: password).subscribe(onNext: { [weak self] response in
            guard let self = self else { return }

            if response.error != nil {
                self.errorMsg = response.error!
                return
            }

            if response.token != nil {
                UserDefaults.standard.set(response.token, forKey: "token")
                self.isLoggedIn = true
            }
        }, onError: { error in
            self.errorMsg = "Something went wrong"
            print(error)
        }).disposed(by: disposeBag)
    }

    // MARK: Private methods

    private func isValidEmail(string: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: string)
    }
}
