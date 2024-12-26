//
//  SignUpView.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/13/24.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var userName: String = ""
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var errorMessage: String? = ""
    @Binding var showLogin: Bool
    @FocusState private var focusedField: FocusField?
    
    var onSignUpComplete: ((String, String) -> Void)?
    
    enum FocusField {
        case userName, phoneNumber, email, password
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                Text("회원가입")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                // 사용자 이름 입력
                inputField(
                    placeholder: "사용자 이름",
                    text: $userName,
                    icon: "person.fill",
                    focusField: .userName
                )
                
                // 핸드폰 번호 입력
                phoneNumberField()
                inputField(
                    placeholder: "아이디 (이메일)",
                    text: $email,
                    icon: "envelope.fill",
                    focusField: .email,
                    keyboardType: .emailAddress
                )
                
                // 비밀번호 입력
                inputField(
                    placeholder: "비밀번호",
                    text: $password,
                    icon: "key.fill",
                    focusField: .password,
                    isSecure: true
                )
                
                Spacer()
                
                // 회원가입 버튼
                Button {
                    hideKeyboard()
                    signUp()
                } label: {
                    Text("회원가입")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(userName.isEmpty || phoneNumber.isEmpty || email.isEmpty || password.isEmpty ? Color.gray : Color.main, in: RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40)
                }
                .disabled(userName.isEmpty || phoneNumber.isEmpty || email.isEmpty || password.isEmpty)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(errorMessage == nil ? "회원가입 성공" : "회원가입 실패"),
                        message: Text(errorMessage ?? "회원가입이 완료되었습니다."),
                        dismissButton: .default(Text("확인")) {
                            if errorMessage == nil {
                                onSignUpComplete?(email, password)
                                showLogin = false
                            }
                        }
                    )
                }
                Spacer()
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    private func signUp() {
        print("사용자 정보 저장: \(email), \(password)")
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
                return
            }
            self.errorMessage = nil
            self.showAlert = true
        }
    }
    
    @ViewBuilder
    private func inputField(placeholder: String, text: Binding<String>, icon: String, focusField: FocusField, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(focusedField == focusField ? Color.main : Color.gray)
            if isSecure {
                SecureField(placeholder, text: text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 15)
            } else {
                TextField(placeholder, text: text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(.never)
                    .padding(.vertical, 15)
            }
        }
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(focusedField == focusField ? Color.main : Color.gray),
            alignment: .bottom
        )
        .focused($focusedField, equals: focusField)
        .padding(.horizontal, 40)
    }
    
    private func phoneNumberField() -> some View {
        HStack(spacing: 10) {
            Image(systemName: "phone.fill")
                .foregroundColor(focusedField == .phoneNumber ? Color.main : Color.gray)
            TextField("핸드폰 번호", text: $phoneNumber)
                .textFieldStyle(PlainTextFieldStyle())
                .keyboardType(.numberPad)
                .textInputAutocapitalization(.never)
                .onChange(of: phoneNumber) { newValue in
                    phoneNumber = formatPhoneNumber(newValue)
                }
                .padding(.vertical, 15)
        }
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(focusedField == .phoneNumber ? Color.main : Color.gray),
            alignment: .bottom
        )
        .focused($focusedField, equals: .phoneNumber)
        .padding(.horizontal, 40)
    }
    
    // 핸드폰 번호 포맷팅 함수
    private func formatPhoneNumber(_ number: String) -> String {
        let digits = number.filter { $0.isNumber }.prefix(11)
        switch digits.count {
        case 0...3:
            return String(digits)
        case 4...7:
            return "\(digits.prefix(3))-\(digits.suffix(digits.count - 3))"
        default:
            let middleIndex = digits.index(digits.startIndex, offsetBy: 3)
            let endIndex = digits.index(middleIndex, offsetBy: 4, limitedBy: digits.endIndex) ?? digits.endIndex
            let prefix = digits[..<middleIndex]
            let middle = digits[middleIndex..<endIndex]
            let suffix = digits[endIndex...]
            return "\(prefix)-\(middle)-\(suffix)"
        }
    }
}

#Preview {
    SignUpView(showLogin: .constant(true))
}
