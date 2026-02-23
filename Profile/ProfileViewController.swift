//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Илья Геннадьевич on 08.02.2026.
//
import UIKit

class ProfileViewController: UIViewController {

private let imageView = UIImageView()
private let logoutButton = UIButton()
private let loginNameLabel = UILabel()
private let nameLabel = UILabel()
private let discriptionLabel = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupImageView() {
        imageView.image = UIImage(named: "Avatar")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
    }
        
    private func setuplogoutButton() {
        logoutButton.setImage(UIImage(named: "Exit"), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
    }
        
    private func setupLoginNameLabel() {
        loginNameLabel.text = "@ekaterina_novikova"
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.textColor = UIColor(named: "GrayColor")
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
    }
    
    private func setupNameLabel() {
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
    }
    
    private func setupDiscriptionLabel() {
        discriptionLabel.text = "Hello, world!"
        discriptionLabel.font = UIFont.systemFont(ofSize: 13)
        discriptionLabel.textColor = .white
        discriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(discriptionLabel)
    }
        
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            
            loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            
            
            discriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            discriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            
            
        ])
    }
    
    private func setupUI() {
        setupImageView()
        setuplogoutButton()
        setupLoginNameLabel()
        setupNameLabel()
        setupDiscriptionLabel()
        setupConstraints()
    }
    
}
