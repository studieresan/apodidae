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

    private let disposeBag = DisposeBag()

    // MARK: Public methods

    func login(email: String, password: String) {
        print("Attempting login")
        // Fetch the events
        Http.login(email: email, password: password).subscribe(onNext: { [weak self] response in
            //guard let self = self else { return }

            print(response)
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }
}
