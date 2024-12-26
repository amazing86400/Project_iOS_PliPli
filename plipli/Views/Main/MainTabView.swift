//
//  MainTabView.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/16/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selection = 1
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                PlaylistView()
                    .padding()
                    .tag(0)
                
                HomeView()
                    .padding()
                    .tag(1)
                
                SearchView()
                    .padding()
                    .tag(2)
            }
            .tabViewStyle(.page)
            
            TabBarController(selection: $selection)
            
            MusicBarController()
                .padding(.horizontal, 10)
                .padding(.bottom, 90)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthenticationViewModel())
}
