//
//  TabBarController.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/20/24.
//

import SwiftUI

struct TabBarController: View {
    @Binding var selection: Int
    
    var body: some View {
        HStack {
            Spacer()
            tabBarButton(img: "square.grid.2x2.fill", text: "보관함", tag: 0)
            Spacer()
            tabBarButton(img: "music.note.house.fill", text: "홈", tag: 1)
            Spacer()
            tabBarButton(img: "magnifyingglass", text: "검색", tag: 2)
            Spacer()
        }
        .padding(.top, 10)
        .frame(height: 110)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.gray.opacity(0.2),
                    Color.gray.opacity(0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .blur(radius: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func tabBarButton(img: String, text: String, tag: Int) -> some View {
        Button {
            selection = tag
        } label: {
            VStack {
                Spacer(minLength: 25)
                Image(systemName: img)
                    .resizable()
                    .frame(width: 25, height: 25)
                Text(text)
                    .font(.caption)
                Spacer()
            }
        }
        .foregroundStyle(selection == tag ? .main : .gray)
    }
}

#Preview {
    @Previewable @State var num = 1
    TabBarController(selection: $num)
}
