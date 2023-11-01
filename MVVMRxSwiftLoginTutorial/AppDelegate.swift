//
//  AppDelegate.swift
//  MVVMRxSwiftLoginTutorial
//
//  Created by KIM Hyung Jun on 10/30/23.
//

import UIKit
import Firebase
import GoogleSignIn
import RxKakaoSDKCommon
import RxKakaoSDKAuth
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase 초기화
        FirebaseApp.configure()
        
        // 메인 번들에 있는 카카오 앱키 불러오기
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        // 카카오 SDK 초기화
        RxKakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        return true
    }
    
    // 구글의 인증 프로세스가 끝날 때 앱이 수신하는 URL을 처리하는 역할
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         var handled: Bool
         
         handled = GIDSignIn.sharedInstance.handle(url)
         
         if handled {
             return true
         }
        
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.rx.handleOpenUrl(url: url)
        }
         
         return false
     }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

