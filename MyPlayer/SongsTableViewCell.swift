//
//  SongsTableViewCell.swift
//  MyPlayer
//
//  Created by ROMAN VRONSKY on 14.01.2023.
//

import UIKit

class SongsTableViewCell: UITableViewCell {
    let color = #colorLiteral(red: 0.9296384454, green: 0.9451069236, blue: 0.9368827939, alpha: 1)
    
    private lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func setup(text: String) {
        self.songNameLabel.text = text
    }
    
    private func setupView() {
        self.contentView.backgroundColor = color
        self.contentView.addSubview(self.songNameLabel)
        
        NSLayoutConstraint.activate([
        
            self.songNameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.songNameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5)
        
        ])
    }
    
    
}
