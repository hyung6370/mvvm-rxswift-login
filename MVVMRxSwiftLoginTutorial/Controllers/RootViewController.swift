//
//  RootViewController.swift
//  MVVMRxSwiftLoginTutorial
//
//  Created by KIM Hyung Jun on 10/30/23.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabaseInternal
import AuthenticationServices
import Crypto


class RootViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = LoginViewModel()
    
    let userEmail = "test@test.com"
    let userPassword = "test123"
    
    fileprivate var currentNonce: String?
    
    // Properties
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.text = "RxSwift & MVVM & Login Validation"
    }
    
    private let emailView = UIView().then {
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private let emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    private let passwordView = UIView().then {
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private let passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.isSecureTextEntry = true
    }
    
    private let loginButton = UIButton().then {
        $0.setTitle("Login", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = #colorLiteral(red: 0.6, green: 0.8078431373, blue: 0.9803921569, alpha: 1)
        $0.layer.cornerRadius = 15
    }
    
    private let googleButton = UIButton().then {
        $0.setTitle("Google로 로그인하기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = #colorLiteral(red: 0.0548138991, green: 0.6635760665, blue: 0.9648820758, alpha: 1)
        $0.layer.cornerRadius = 15
    }
    
    private let kakaoButton = UIButton().then {
        $0.setTitle("Kakao로 로그인하기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = #colorLiteral(red: 0.9297463298, green: 0.921446979, blue: 0.1752431393, alpha: 1)
        $0.layer.cornerRadius = 15
    }
    
    private let appleButton = UIButton().then {
        $0.setTitle("Apple로 로그인하기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        $0.layer.cornerRadius = 15
    }
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupControl()
        configureUI()
        
    }

    // Helpers
    func configureUI() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(emailView)
        emailView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.height.equalTo(50)
        }
        
        emailView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        view.addSubview(passwordView)
        passwordView.snp.makeConstraints {
            $0.top.equalTo(emailView.snp.bottom).offset(10)
            $0.leading.equalTo(emailView.snp.leading)
            $0.trailing.equalTo(emailView.snp.trailing)
            $0.height.equalTo(50)
        }
        
        passwordView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordView.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(emailView)
        }
        
        view.addSubview(googleButton)
        googleButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(emailView)
        }
        
        view.addSubview(kakaoButton)
        kakaoButton.snp.makeConstraints {
            $0.top.equalTo(googleButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(emailView)
        }
        
        view.addSubview(appleButton)
        appleButton.snp.makeConstraints {
            $0.top.equalTo(kakaoButton.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(emailView)
        }
    }
    
    func setupControl() {
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.emailObserver)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.passwordObserver)
            .disposed(by: disposeBag)
        
        viewModel.isValid.bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .map { $0 ? 1 : 0.3 }
            .bind(to: loginButton.rx.alpha)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe (
            onNext: { [weak self] _ in
                if self?.userEmail == self?.viewModel.emailObserver.value &&
                    self?.userPassword == self?.viewModel.passwordObserver.value {
                    let alert = UIAlertController(title: "로그인 성공", message: "환영합니다.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default) { _ in
                        let homeVC = HomeViewController()
                        self?.navigationController?.pushViewController(homeVC, animated: true)
                    }
                    alert.addAction(ok)
                    self?.present(alert, animated: true, completion: nil)
                }
                else {
                    let alert = UIAlertController(title: "로그인 실패", message: "아이디 혹은 비밀번호를 다시 확인해주세요.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(ok)
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        ).disposed(by: disposeBag)
        
        
        // MARK: - Google Login
        googleButton.rx.tap.subscribe(
            onNext: { [weak self] in
                self?.handleGoogleLogin()
            }).disposed(by: disposeBag)
        
        
        // MARK: - Kakao Login
        
        
        
        // MARK: - Apple Login
        appleButton.rx.tap.subscribe(
            onNext: { [weak self] in
                self?.startSignInWithAppleFlow()
            }).disposed(by: disposeBag)
        
        
        
    }
    
    private func handleGoogleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
        guard error == nil else {
            return
        }

        guard let user = result?.user, let idToken = user.idToken?.tokenString else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                guard let authUser = authResult?.user, error == nil else {
                    return
                }
                
                let ref = Database.database().reference()
                ref.child("users").child(authUser.uid).setValue(["email": authUser.email])
                
                let homeVC = HomeViewController()
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
        }
    }
}

// MARK: - Apple Login
@available(iOS 13.0, *)
extension RootViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
        }

        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                            rawNonce: nonce,
                                                            fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                  // Error. If error.code == .MissingOrInvalidNonce, make sure
                  // you're sending the SHA256-hashed nonce as a hex string with
                  // your request to Apple.
                    print(error.localizedDescription)
                    return
                }
            // User is signed in to Firebase with Apple.
            // ...
              
                self.dismiss(animated: true)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}
