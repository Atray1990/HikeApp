//
//  CharacterDetailViewController.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import UIKit
import SDWebImage

final class CharacterDetailViewController: UIViewController {
    
    private let viewModel: CharacterDetailViewModel
    
    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let statusBadge = UILabel()
    
    private let infoStack = UIStackView()
    private let episodesTableView = UITableView()
    
    // MARK: - Init
    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        configure()
    }
    
    func setupUI() {
            view.backgroundColor = .systemBackground
            title = "Character Details"
            
            contentStack.axis = .vertical
            contentStack.spacing = 16
            
            infoStack.axis = .vertical
            infoStack.spacing = 8
            
            episodesTableView.register(EpisodeCell.self, forCellReuseIdentifier: "EpisodeCell")
            episodesTableView.isScrollEnabled = true
            episodesTableView.dataSource = self
            episodesTableView.allowsSelection = false
        
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            statusBadge.layer.cornerRadius = 10
            statusBadge.clipsToBounds = true
            statusBadge.textAlignment = .center
            statusBadge.textColor = .white
            
        [imageView, nameLabel, statusBadge, infoStack].forEach {
            contentStack.addArrangedSubview($0)
        }

        view.addSubview(scrollView)
        view.addSubview(episodesTableView)
        scrollView.addSubview(contentStack)
        }
    
    func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        episodesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
            episodesTableView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            episodesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            episodesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            episodesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    func configure() {
       
        nameLabel.text = viewModel.character.name
            
        statusBadge.text = " \(viewModel.character.status) "
            statusBadge.backgroundColor = {
                switch viewModel.character.status.lowercased() {
                case "alive": return .systemGreen
                case "dead": return .systemRed
                default: return .systemGray
                }
            }()
            
            let fields = [
                "Species: \(viewModel.character.species)",
                "Gender: \(viewModel.character.gender)",
                "Origin: \(viewModel.character.origin.name)",
                "Location: \(viewModel.character.location.name)"
            ]
            
            fields.forEach {
                let label = UILabel()
                label.text = $0
                label.font = .systemFont(ofSize: 14)
                infoStack.addArrangedSubview(label)
            }
            
            if let url = URL(string: viewModel.character.image) {
                imageView.sd_setImage(with: url)
            }
            
        self.episodesTableView.reloadData()
        }
}

extension CharacterDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfEpisode
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let episode = viewModel.getObjectAtIndexPath(indexPathRow: indexPath.row) else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
        cell.configure(episode)
        return cell
    }
}
