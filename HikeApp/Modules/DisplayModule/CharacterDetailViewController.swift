//
//  CharacterDetailViewController.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import UIKit
import SDWebImage

final class CharacterDetailViewController: UIViewController {
    
    private let character: Character? = nil
    
    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let statusBadge = UILabel()
    
    private let infoStack = UIStackView()
    private let episodesTableView = UITableView()
    
    // MARK: - Init
    init(character: Character? = nil) {
        self.character = character
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
            
            episodesTableView.dataSource = self
            episodesTableView.register(EpisodeCell.self, forCellReuseIdentifier: "EpisodeCell")
            episodesTableView.isScrollEnabled = false
            
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            statusBadge.layer.cornerRadius = 10
            statusBadge.clipsToBounds = true
            statusBadge.textAlignment = .center
            statusBadge.textColor = .white
            
            [imageView, nameLabel, statusBadge, infoStack, episodesTableView].forEach {
                contentStack.addArrangedSubview($0)
            }
            
            scrollView.addSubview(contentStack)
            view.addSubview(scrollView)
        }
    
    func setupConstraints() {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            contentStack.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
                contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
        }
    
    func configure() {
        guard let character = character else {
            return
        }
            nameLabel.text = character.name
            
            statusBadge.text = " \(character.status) "
            statusBadge.backgroundColor = {
                switch character.status.lowercased() {
                case "alive": return .systemGreen
                case "dead": return .systemRed
                default: return .systemGray
                }
            }()
            
            let fields = [
                "Species: \(character.species)",
                "Gender: \(character.gender)",
                "Origin: \(character.origin.name)",
                "Location: \(character.location.name)"
            ]
            
            fields.forEach {
                let label = UILabel()
                label.text = $0
                label.font = .systemFont(ofSize: 14)
                infoStack.addArrangedSubview(label)
            }
            
            if let url = URL(string: character.image) {
                imageView.sd_setImage(with: url)
            }
        }
        
       
}

extension CharacterDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        character?.episode.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
        cell.configure(character?.episode[indexPath.row])
        return cell
    }
}
