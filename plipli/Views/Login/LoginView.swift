//
//  LoginView.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/11/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = "rlqja9141@naver.com"
    @State private var password: String = "varTest2024!"
    @State private var showMain: Bool = false
    @State private var showAlert: Bool = false
    @State private var showSignUp: Bool = false
    @State private var errorMessage: String?
    @FocusState private var focusedField: FocusField?
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    enum FocusField {
        case email, password
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // 로고
            Text("PLIPLI")
                .font(.largeTitle)
                .bold()
            
            Spacer(minLength: 30)
            
            // 아이디 입력
            TextField("아이디 (이메일)", text: $email)
                .padding(15)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .background(focusedField == .email ? Color.gray.opacity(0.1) : Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(focusedField == .email ? Color.gray : Color.gray.opacity(0.5), lineWidth: 1)
                )
                .focused($focusedField, equals: .email)
                .padding(.horizontal, 40)
            
            // 비밀번호 입력
            SecureField("비밀번호", text: $password)
                .padding(15)
                .background(focusedField == .password ? Color.gray.opacity(0.1) : Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(focusedField == .email ? Color.gray : Color.gray.opacity(0.5), lineWidth: 1)
                )
                .focused($focusedField, equals: .password)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            
            // 로그인 버튼
            Button {
                signInWithApp()
            } label: {
                Text("로그인")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.main)
                    .foregroundStyle(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    .padding(.horizontal, 40)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("로그인 실패"),
                    message: Text(errorMessage ?? "로그인에 실패했습니다."),
                    dismissButton: .default(Text("확인"))
                )
            }
            .fullScreenCover(isPresented: $showMain) {
                MainTabView()
            }
            
            // 회원가입 버튼
            Button {
                showSignUp = true
            } label: {
                Text("회원가입")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .font(.subheadline)
                    .foregroundStyle(Color.main)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10).stroke(Color.main, lineWidth: 1)
                            .shadow(radius: 1)
                    }
                    .padding(.horizontal, 40)
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView(showLogin: $showSignUp) { email, password in
                    self.email = email
                    self.password = password
                }
            }
            
            ZStack {
                Divider()
                    .padding(40)
                Text("또는")
                    .padding(15)
                    .background(Color.white)
                    .foregroundStyle(Color.gray)
            }
            
            // 구글 로그인 버튼
            Button {
                authViewModel.signInWithGoogle()
                print(authViewModel.state)
                if authViewModel.state == .signedIn {
                    showMain = true
                }
            } label: {
                HStack {
                    Image("GoogleLogo")
                        .resizable()
                        .scaledToFit()
                    Text("Sign in with Google")
                        .foregroundStyle(Color.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1)
                        .shadow(radius: 1)
                })
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear() {
            print(authViewModel.state)
        }
    }
    
    private func signInWithApp() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
                self.showMain = false
                return
            } else {
                self.errorMessage = nil
                self.showAlert = false
                self.showMain = true
                return
            }
        }
    }
}

// 키보드 숨기기 로직
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

private extension LoginView {
    var rootViewController: UIViewController? {
        return UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap { $0 as? UIWindowScene }
            .compactMap { $0.keyWindow }
            .first?.rootViewController
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationViewModel())
}
