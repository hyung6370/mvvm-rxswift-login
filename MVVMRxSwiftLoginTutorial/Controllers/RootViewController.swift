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

class RootViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = LoginViewModel()
    
    let userEmail = "test@test.com"
    let userPassword = "test123"
    
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
        
        googleButton.rx.tap.subscribe(
            onNext: { [weak self] in
                self?.handleGoogleLogin()
            }).disposed(by: disposeBag)
        
        
        
        
        // MARK: - Google Login
        
        
        
        // MARK: - Kakao Login
        
        
        // MARK: - Apple Login
        
    }
    
    private func handleGoogleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { _,_ in
                self.dismiss(animated: true)
            }
        }
    }
}
