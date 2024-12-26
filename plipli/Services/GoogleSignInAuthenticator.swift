//
//  GoogleSignInAuthenticator.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

final class GoogleSignInAuthenticator {
    static let shared = GoogleSignInAuthenticator()
    
    private init() {}
    
    // Google을 사용해서 로그인하고 Firebase와 통합
    // 로그인 함수 정의: Returns `true` on success, `false` on failure.
    func signIn(completion: @escaping (Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Google ClientID 가져오기 실패")
            completion(false)
            return
        }

        _ = GIDConfiguration(clientID: clientID)

        // rootViewController 가져오기
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController else {
            print("Root View Controller 가져오기 실패")
            completion(false)
            return
        }

        // Google Sign-In process 시작
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if let error = error {
                print("Google 로그인 실패: \(error.localizedDescription)")
                completion(false)
                return
            }

            // Google Sign-In tokens 가져오기
            guard let idToken = signInResult?.user.idToken?.tokenString,
                  let accessToken = signInResult?.user.accessToken.tokenString else {
                print("Google 인증 정보 없음")
                completion(false)
                return
            }

            // Firebase credential 생성
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            // Firebase 인증
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Firebase 로그인 실패: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Firebase 로그인 성공: \(result?.user.email ?? "알 수 없음")")
                    completion(true)
                }
            }
        }
    }
    
    // 사용자 연결을 끊고 Firebase에서 로그아웃
    // 로그아웃 함수 정의: Returns `true` on success, `false` on failure.
    func disconnect(completion: @escaping (Bool) -> Void) {
        GIDSignIn.sharedInstance.disconnect { error in
            if let error = error {
                print("Google 계정 연결 해제 실패: \(error.localizedDescription)")
                completion(false)
            } else {
                do {
                    try Auth.auth().signOut()
                    print("Google 계정 연결 해제 및 로그아웃 성공")
                    completion(true)
                } catch {
                    print("Firebase 로그아웃 실패: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
}
