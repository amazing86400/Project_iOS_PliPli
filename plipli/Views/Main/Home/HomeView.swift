//
//  HomeView.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/19/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, World!")
            }
            .navigationTitle("홈")
        }
    }
}

#Preview {
    HomeView()
}
