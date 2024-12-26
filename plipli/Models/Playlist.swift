//
//  Playlist.swift
//  plipli
//
//  Created by KIBEOM SHIN on 12/24/24.
//

import Foundation
import UIKit

struct Playlist: Identifiable {
    let id: UUID = UUID()
    var name: String
    var songs: [String]
    var image: UIImage?
    var share: Bool
}
