//
//  ViewController.swift
//  YourUIKitApp
//
//  Created by Lê Quang Trọng Tài on 11/8/22.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var emailLableOl: UILabel!
    @IBOutlet weak var repeatPasswordLableOl: UILabel!
    @IBOutlet weak var passwordLableOl: UILabel!
    @IBOutlet weak var repeatPasswordTextFieldOl: UITextField!
    @IBOutlet weak var passwordTextFieldOl: UITextField!
    @IBOutlet weak var emailTextFieldOl: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signUpLableOl: UILabel!
    @IBOutlet weak var resendEmailButton: UIButton!
    @IBOutlet weak var repeatPasswordLineView: UIView!

    var isLogin = true

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIActionFor(isLogin: true)
        setupTextFieldDelegate()
    }

    // MARK: - Assign Delegate
    func setupTextFieldDelegate() {
        emailTextFieldOl.addTarget(
            self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextFieldOl.addTarget(
            self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        repeatPasswordTextFieldOl.addTarget(
            self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        updatePlaceholderLables(textField)
    }

    private func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func backgroundTap() {
        view.endEditing(false)
    }

    // MARK: - Press function
    @IBAction func signUpPress(_ sender: UIButton) {
        updateUIActionFor(isLogin: sender.titleLabel?.text == "Sign In")
        isLogin.toggle()
    }

    @IBAction func forgotPasswordPress(_ sender: Any) {
        resendPasswordReset()
    }

    func resendPasswordReset() {
        FirebaseUserListener.shared.resetPasswordFor(email: emailTextFieldOl.text!) { error in
            if error == nil {
                print("Sucess send forgot password!")
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    @IBAction func resendEmailPress(_ sender: Any) {
        resendEmailPress()
    }

    func resendEmailPress() {
        FirebaseUserListener.shared.resendVerificationEmail(email: emailTextFieldOl.text!) {
            error in
            if error == nil {
                print("Email Request Resend!")
            }
        }
    }

    @IBAction func signInButtonPress(_ sender: UIButton) {
        FirebaseUserListener.shared.loginUserWithEmail(
            email: emailTextFieldOl.text!, password: passwordTextFieldOl.text!
        ) { error, isEmailVerified in
            if isEmailVerified {
                self.goToApp()
            }
        }
    }

    // MARK: - Animation
    private func updatePlaceholderLables(_ textField: UITextField) {
        switch textField {
        case emailTextFieldOl:
            emailLableOl.text = textField.hasText ? "Email" : .isEmpty
        case passwordTextFieldOl:
            passwordLableOl.text = textField.hasText ? "Password" : .isEmpty
        case repeatPasswordTextFieldOl:
            repeatPasswordLableOl.text = textField.hasText ? "Repeat Password" : .isEmpty
        default:
            break
        }
    }

    func updateUIActionFor(isLogin: Bool) {
        signInButton.setTitle(isLogin ? "Sign In" : "Sign Up", for: .normal)
        signUpLableOl.text = isLogin ? "Don't have account?" : "Have an account?"
        signUpButton.setTitle(isLogin ? "Sign Up" : "Sign In", for: .normal)
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordLableOl.isHidden = isLogin
            self.repeatPasswordTextFieldOl.isHidden = isLogin
            self.repeatPasswordLineView.isHidden = isLogin
        }
    }

    func goToApp() {
        let mainView =
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
                withIdentifier: "MainApp") as! UITabBarController
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true) {
        }
    }
}
