//
//  PlaylistView.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/19/24.
//

import SwiftUI

struct PlaylistView: View {
    @StateObject private var viewModel: PlaylistViewModel = PlaylistViewModel()
    @State private var showAddPlist: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.playlists.isEmpty {
                    // 플레이리스트가 없을 때
                    emptyPlaylistView
                } else {
                    // 플레이리스트가 있을 때
                    playlistListView
                }
            }
            .navigationTitle("보관함")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.playlists.isEmpty {
                        Button("추가") {
                            showAddPlist = true
                        }
                    } else {
                        Button("편집") {
                            // 편집 동작
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddPlist) {
                AddPlaylistView(showPlist: $showAddPlist) { name, image, share in
                    viewModel.addPlist(name: name, image: image, share: share)
                }
            }
        }
    }
    
    // 플레이리스트가 없을 때 보여줄 뷰
    private var emptyPlaylistView: some View {
        VStack(spacing: 10) {
            Image(systemName: "questionmark.folder")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .padding(.bottom, 20)
                .foregroundStyle(.gray.opacity(0.8))
            
            Text("플레이리스트가 없습니다")
                .font(.title3)
            
            Text("나만의 플레이리스트를 추가하세요")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    // 플레이리스트 리스트 뷰
    private var playlistListView: some View {
        List {
            ForEach(viewModel.playlists) { playlist in
                NavigationLink(destination: PlaylistDetailView()) {
                    PlaylistRow(plist: playlist)
                }
            }
            .onDelete(perform: viewModel.deletePlist)
        }
        .listStyle(InsetGroupedListStyle())
    }
}

#Preview {
    PlaylistView()
}
