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
    private let disposeBag = DisposeBag()

    // What should happen when the errorMsg is changed
    var onErrorMsgChange: ((String) -> Void)?

    // MARK: Public methods

    func login(email: String, password: String) {
        print("Attempting login")
        // Fetch the events
        Http.login(email: email, password: password).subscribe(onNext: { [weak self] response in
            //guard let self = self else { return }

            print("Response:")
            print(response)

            if response.error != nil {
                self?.errorMsg = response.error!
                return
            }
        }, onError: { error in
            print("Error:")
            print(error)
        }).disposed(by: disposeBag)
    }
}
