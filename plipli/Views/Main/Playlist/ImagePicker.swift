//
//  ImagePicker.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/24/24.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage? // 선택된 이미지를 전달
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary // 앨범에서 선택
        
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // 업데이트 로직 필요 없음
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    // Coordinator for UIImagePickerController
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image // 선택된 이미지를 바인딩
            }
            parent.presentationMode.wrappedValue.dismiss() // Picker 닫기
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss() // Picker 닫기
        }
    }
}


#Preview {
    ImagePicker(selectedImage: .constant(.googleLogo))
}
