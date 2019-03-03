//
//  LoginViewController.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-23.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self

        // Clear the error label on load
        errorLabel.text = ""

        viewModel.onErrorMsgChange = { [weak self] (errorMsg) in
            DispatchQueue.main.async {
                self?.errorLabel.text = errorMsg
            }
        }
    }

    // MARK: Actions

    @IBAction func didTapLogin(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text

        if email == "" || password == "" {
            return
        }

        print(email!)
        print(password!)
        viewModel.login(email: email!, password: password!)
    }

    // Dismiss keyboard when tapping anywhere outside text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
