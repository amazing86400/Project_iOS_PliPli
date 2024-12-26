//
//  PlaylistViewModel.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/24/24.
//

import Foundation
import UIKit

class PlaylistViewModel: ObservableObject {
    @Published var playlists: [Playlist] = []

    // 플레이리스트 추가
    func addPlist(name: String, image: UIImage? = nil, share: Bool = false) {
        let newPlist = Playlist(name: name, songs: [], image: image, share: share)
        playlists.append(newPlist)
    }

    // 플레이리스트 삭제
    func deletePlist(at offsets: IndexSet) {
        playlists.remove(atOffsets: offsets)
    }
}
