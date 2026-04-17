//
//  CharacterDetailViewModel.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import Foundation

protocol CharacterDetailViewModelProtocol {
    var characterListingAPIManager: CharacterListingTaskProtocol { get } // this can be used if the api is there to get the id list
    var observer: ((VCEvent)->Void)? { set get }
    var numberOfEpisode: Int { get }
    func getObjectAtIndexPath(indexPathRow: Int) -> String?
}

final class CharacterDetailViewModel {

    private(set) var character: Character
 
    
    var onUpdate: (() -> Void)?
    
    init(character: Character) {
        self.character = character
    }
    
    var numberOfEpisode: Int {
        character.episode.count
    }
    
    
    func getObjectAtIndexPath(indexPathRow: Int) -> String? {
        return character.episode[indexPathRow]
    }
}
