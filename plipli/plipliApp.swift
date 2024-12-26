//
//  plipliApp.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/11/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct plipliApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(authViewModel)
                .onAppear {
                    // GoogleSignIn 상태 복원 및 Firebase 상태 동기화
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        if let user = user {
                            // GoogleSignIn 성공, Firebase로 상태 동기화
                            let idToken = user.idToken!.tokenString
                            let accessToken = user.accessToken.tokenString
                            
                            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                            Auth.auth().signIn(with: credential) { _, error in
                                DispatchQueue.main.async {
                                    if error != nil {
                                        authViewModel.state = .signedOut
                                    } else {
                                        authViewModel.state = .signedIn
                                    }
                                }
                            }
                        } else if let error = error {
                            // 복원 실패
                            authViewModel.state = .signedOut
                            print("Google 로그인 복원 실패: \(error.localizedDescription)")
                        } else {
                            // 사용자 인증 상태 없음
                            authViewModel.state = .signedOut
                        }
                    }
                }
                .onOpenURL { url in
                    // Google 로그인 URL 처리
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
