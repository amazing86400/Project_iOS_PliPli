//
//  MusicBarController.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/23/24.
//

import SwiftUI

struct MusicBarController: View {
    var body: some View {
        HStack {
            Image(.googleLogo)
                .resizable()
                .scaledToFit()
            Text("Title")
                .font(.headline)
            Spacer()
            playButton(img: "backward.end.fill")
            playButton(img: "play.fill")
            playButton(img: "forward.end.fill")
        }
        .padding(.horizontal, 30)
        .frame(height: 50)
        .background(.white, in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
        )
        .shadow(radius: 2)
    }
    
    @ViewBuilder
    private func playButton(img: String) -> some View {
        Button {
            
        } label: {
            Image(systemName: img)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(.gray)
        }
        .padding(.horizontal, 3)
    }
}

#Preview {
    MusicBarController()
}
