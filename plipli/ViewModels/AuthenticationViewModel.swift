//
//  AuthenticationViewModel.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/11/24.
//

import SwiftUI
import FirebaseAuth

// 사용자의 인증 상태를 나타내는 데 사용
final class AuthenticationViewModel: ObservableObject {
    // 사용자의 인증 상태
    @Published var state: State = .signedOut
    
    init() {
        // Firebase의 현재 사용자를 기반으로 상태 초기화
        if Auth.auth().currentUser != nil {
            self.state = .signedIn
        } else {
            self.state = .signedOut
        }
    }
    
    // Google을 사용하여 사용자를 로그인
    func signInWithGoogle() {
        GoogleSignInAuthenticator.shared.signIn { [weak self] success in
            DispatchQueue.main.async {
                self?.state = success ? .signedIn : .signedOut
            }
        }
    }
    
    // 사용자 로그아웃
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.state = .signedOut
            }
        } catch {
            print("Sign out failed: \(error.localizedDescription)")
        }
    }
    
    // Google에서 사용자 연결을 끊고 로그아웃
    func disconnect() {
        GoogleSignInAuthenticator.shared.disconnect { [weak self] success in
            if success {
                self?.signOut()
            }
        }
    }
}

// 로그인 상태를 나타내는 열거형
extension AuthenticationViewModel {
    enum State {
        case signedIn, signedOut
    }
}

