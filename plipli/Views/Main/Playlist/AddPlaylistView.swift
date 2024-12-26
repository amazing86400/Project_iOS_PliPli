//
//  AddPlaylistView.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/23/24.
//

import SwiftUI

struct AddPlaylistView: View {
    @State private var plistName: String = ""
    @State private var isShare: Bool = false
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    @State private var showAlert = false
    @Binding var showPlist: Bool
    @FocusState private var isTextFieldFocused: Bool
    
    var onAdd: ((String, UIImage?, Bool) -> Void)?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer().frame(height: 20)
                
                // 앨범 버튼
                Button {
                    showImagePicker = true
                } label: {
                    ZStack {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 2)
                        } else {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 250, height: 250)
                                .foregroundStyle(Color.myGray1)
                            Image(systemName: "camera.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70)
                                .shadow(radius: 2)
                        }
                    }
                }
                
                // 플레이리스트 이름 입력
                VStack(spacing: 15) {
                    ZStack {
                        if plistName.isEmpty && !isTextFieldFocused {
                            Text("플레이리스트 이름")
                                .foregroundColor(.gray)
                                .font(.title2)
                                .padding(.horizontal, 60)
                        }
                        TextField("", text: $plistName)
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .padding(.horizontal, 60)
                            .focused($isTextFieldFocused)
                    }
                    
                    Divider()
                        .padding(.horizontal, 15)
                        .foregroundStyle(.gray)
                }
                
                // 공유 옵션 토글
                Toggle(isOn: $isShare) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("다른 사람과 공유하기")
                            .font(.headline)
                        Text("사람들과 플레이리스트를 공유할 수 있어요")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if plistName.isEmpty {
                            showAlert = true
                        } else {
                            onAdd?(plistName, selectedImage, isShare)
                            showPlist = false
                        }
                    } label: {
                        Text("완료")
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage) // 이미지 선택 뷰
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("플레이리스트 이름을 입력해 주세요"))
            }
        }
//        .onTapGesture {
//            hideKeyboard()
//        }
    }
}


#Preview {
    AddPlaylistView(showPlist: .constant(true))
}
