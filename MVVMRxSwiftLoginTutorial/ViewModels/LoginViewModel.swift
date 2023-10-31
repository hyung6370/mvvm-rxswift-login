//
//  LoginViewModel.swift
//  MVVMRxSwiftLoginTutorial
//
//  Created by KIM Hyung Jun on 10/31/23.
//

import RxSwift
import RxRelay

class LoginViewModel {
    let emailObserver = BehaviorRelay<String>(value: "")
    let passwordObserver = BehaviorRelay<String>(value: "")
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(emailObserver, passwordObserver)
            .map { email, password in
                print("Email: \(email), Password: \(password)")
                return !email.isEmpty && email.contains("@") && email.contains(".") && password.count > 0
            }
    }
}
