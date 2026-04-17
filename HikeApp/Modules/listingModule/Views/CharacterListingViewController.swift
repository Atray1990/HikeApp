//
//  CharacterListingViewController.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//
import UIKit

enum ViewState {
    case listing
    case searching(query: String)
}

final class CharacterListingViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let characterListingTableView = UITableView()
    private let threshold = 15
    private let debouncer = Debouncer(delay: 0.3)
    
    var viewModel: CharacterListingViewModelProtocol = CharacterListingViewModelImpl(
        apiManager: CharacterListingTask()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        makeApiCall()
        registerObserver()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Rick And Morty"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // SearchBar
        searchBar.placeholder = "Search currency"
        searchBar.delegate = self
        
        // TableView
        characterListingTableView.dataSource = self
        characterListingTableView.delegate = self
        characterListingTableView.prefetchDataSource = self
        characterListingTableView.keyboardDismissMode = .onDrag
        characterListingTableView.register(CharacterListingTableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(searchBar)
        view.addSubview(characterListingTableView)
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        characterListingTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            characterListingTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            characterListingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            characterListingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            characterListingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func makeApiCall() {
        characterListingTableView.reloadData()
        Task {
            await self.viewModel.getCharacterListing()
        }
    }
    
    private func registerObserver(){
        viewModel.observer = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .reloadTable:
                DispatchQueue.main.async {
                    if self.viewModel.numberOfCharacters == 0 {
                        let label = UILabel()
                        label.text = "No results found"
                        label.textAlignment = .center
                        label.textColor = .gray
                        self.characterListingTableView.backgroundView = label
                    } else {
                        self.characterListingTableView.backgroundView = nil
                    }
                    
                    self.characterListingTableView.reloadData()
                }
            case .insertItems(_):
                DispatchQueue.main.async {
                    self.characterListingTableView.reloadData()
                }
            default:
                break
            }
        }
    }
    
    @objc private func currencySelectionButtonTapped() {
            
    }
}

extension CharacterListingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCharacters
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let model = viewModel.getObjectAtIndexPath(indexPathRow: indexPath.row) else {
            return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CharacterListingTableViewCell
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.pushToDetailsScreen(from: self, index: indexPath.row)
    }
}

extension CharacterListingViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if viewModel.hasMoreData && indexPaths.contains(where: { $0.row >= viewModel.numberOfCharacters - threshold }) {
            Task {
                await viewModel.loadMoreIfNeeded()
            }
        }
        
    }
}

extension CharacterListingViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            
            Task {
                await viewModel.getCharacterListing()
            }
            return
        }
        
        debouncer.debounce { [weak self] in
            guard let self else { return }
            
            Task {
                await self.viewModel.getSearchedCharacter(searchString: trimmed)
            }
        }
    }
}



