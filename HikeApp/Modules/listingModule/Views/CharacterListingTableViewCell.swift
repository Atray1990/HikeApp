//
//  CharacterListingTableViewCell.swift
//  HikeApp
//
//  Created by shashank atray on 17/04/26.
//

import UIKit
import SDWebImage

final class CharacterListingTableViewCell: UITableViewCell {
    
    private let characterImageView = UIImageView()
    
    private let nameLabel = UILabel()
    private let speciesLabel = UILabel()
    
    private let statusBadgeLabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        selectionStyle = .none
        
        // ImageView
        characterImageView.contentMode = .scaleAspectFill
        characterImageView.clipsToBounds = true
        characterImageView.layer.cornerRadius = 20
        
        // Name
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = .label
        
        // Species
        speciesLabel.font = .systemFont(ofSize: 14)
        speciesLabel.textColor = .secondaryLabel
        
        // Status Badge
        statusBadgeLabel.font = .systemFont(ofSize: 12, weight: .medium)
        statusBadgeLabel.textColor = .white
        statusBadgeLabel.textAlignment = .center
        statusBadgeLabel.layer.cornerRadius = 10
        statusBadgeLabel.clipsToBounds = true
        
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(speciesLabel)
        contentView.addSubview(statusBadgeLabel)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        speciesLabel.translatesAutoresizingMaskIntoConstraints = false
        statusBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            // Avatar
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            characterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 40),
            characterImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Name
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            // Species
            speciesLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            speciesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            speciesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            // Status Badge
            statusBadgeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusBadgeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusBadgeLabel.heightAnchor.constraint(equalToConstant: 20),
            statusBadgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            // Avoid overlap
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusBadgeLabel.leadingAnchor, constant: -8),
            speciesLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusBadgeLabel.leadingAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configure
    func configure(model: Character) {
        nameLabel.text = model.name
        speciesLabel.text = model.species
        
        configureStatusBadge(status: model.status)
        
        if let url = URL(string: model.image) {
            characterImageView.sd_setImage(with: url)
        }
    }
    
    // MARK: - Status Badge Logic
    private func configureStatusBadge(status: String) {
        statusBadgeLabel.text = " \(status) "
        
        switch status.lowercased() {
        case "alive":
            statusBadgeLabel.backgroundColor = .systemGreen
        case "dead":
            statusBadgeLabel.backgroundColor = .systemRed
        default:
            statusBadgeLabel.backgroundColor = .systemGray
        }
    }
}
