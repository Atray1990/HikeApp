//
//  CharacterListingViewModel.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import Foundation
import UIKit
protocol CharacterListingViewModelProtocol {
    var characterListingAPIManager: CharacterListingTaskProtocol { get }
    var observer: ((VCEvent)->Void)? { set get }
    var numberOfCharacters: Int { get }
    var hasMoreData: Bool { get }
    func getCharacterListing() async
    func loadMoreIfNeeded() async
    func getSearchedCharacter(searchString: String) async
    func getObjectAtIndexPath(indexPathRow: Int) -> Character?
    func pushToDetailsScreen(from vc: UIViewController, index: Int)
}

final class CharacterListingViewModelImpl: CharacterListingViewModelProtocol {
    
    var characterListingAPIManager: CharacterListingTaskProtocol
    var observer: ((VCEvent) -> Void)? = nil
    var info: Info?
    var characters: [Character] = []
    var isLoading = false
    private var viewState: ViewState = .listing
    private var currentSearchQuery: String?
    private var isPaginating = false
    
    init(apiManager: CharacterListingTaskProtocol){
        self.characterListingAPIManager = apiManager
    }

    var hasMoreData: Bool {
        characters.count < (info?.count ?? 0)
    }
    
    var numberOfCharacters: Int {
        characters.count
    }
    
    func getObjectAtIndexPath(indexPathRow: Int) -> Character? {
        return characters[indexPathRow]
    }
    
    func pushToDetailsScreen(from vc: UIViewController, index: Int) {
        guard let character = getObjectAtIndexPath(indexPathRow: index) else {
            return
        }
        CharacterDetailRouter.push(from: vc, character: character)
    }
    
}

//MARK: - api calls
extension CharacterListingViewModelImpl {
    func getCharacterListing() async {
        viewState = .listing
        await fetchCharacters(isNewQuery: true)
    }
    
    func getSearchedCharacter(searchString: String) async {
        viewState = .searching(query: searchString)
        await fetchCharacters(isNewQuery: true)
    }
    
    func loadMoreIfNeeded() async {
        guard let next = info?.next else { return }
        await fetchCharacters(isNewQuery: false, next: next)
    }
    
    private func fetchCharacters( isNewQuery: Bool, next: String? = nil) async {
        
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        if isNewQuery {
            info = nil
            characters = []
        }
        
        let query: String? = {
            switch viewState {
            case .listing:
                return nil
            case .searching(let query):
                return query
            }
        }()

        
        let responseModel = await characterListingAPIManager.executeCharacterListingApi(nextUrlString: next, searchString: query)
        
        guard let responseModel else { return }
        
        updateData(responseModel: responseModel, isNewData: isNewQuery)
    }
    
    func updateData(responseModel: RickAndMortyCharacterResponse, isNewData: Bool) {
        info = responseModel.info
        
        if isNewData {
            characters = responseModel.results
        } else {
            characters.append(contentsOf: responseModel.results)
        }
        
        observer?(.reloadTable)
    }
}
