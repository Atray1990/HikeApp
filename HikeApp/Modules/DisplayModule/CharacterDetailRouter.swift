//
//  CharacterDetailRouter.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import Foundation
import UIKit

protocol CharacterDetailRouting {
    static func push(from vc: UIViewController, character: Character)
}

extension CharacterDetailRouting {
    static func push(from vc: UIViewController, character: Character) {
        let playerVC = VideoPlayerViewController(videos: videos, playingIndex: index)
        vc.navigationController?.pushViewController(playerVC, animated: true)
    }
}

struct CharacterDetailRouter: CharacterDetailRouting {
    
}
