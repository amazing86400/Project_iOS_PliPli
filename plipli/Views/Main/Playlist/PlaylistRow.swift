//
//  PlaylistRow.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/24/24.
//

import SwiftUI

struct PlaylistRow: View {
    let plist: Playlist
    
    var body: some View {
        HStack(spacing: 25) {
            if let image = plist.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray.opacity(0.2))
            }
            
            VStack(alignment: .leading) {
                Text(plist.name)
                    .font(.headline)
                Text("\(plist.songs.count) 곡")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

#Preview {
    PlaylistRow(plist: Playlist(name: "Playlist", songs: [], image: nil, share: false))
}
