//
//  SongsTableViewCell.swift
//  MyPlayer
//
//  Created by ROMAN VRONSKY on 14.01.2023.
//

import UIKit

class SongsTableViewCell: UITableViewCell {
    let color = #colorLiteral(red: 0.9296384454, green: 0.9451069236, blue: 0.9368827939, alpha: 1)
    
    var heightConstaint1: NSLayoutConstraint?
    var heightConstaint2: NSLayoutConstraint?
    var heightConstaint3: NSLayoutConstraint?
    var heightConstaint4: NSLayoutConstraint?
    
     lazy var songNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var albumImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "music.mic.circle")
        imageView.tintColor = .gray
        return imageView
    }()
    
    lazy var waveImageView1: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "musicWave")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var waveImageView2: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "musicWave")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var waveImageView3: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "musicWave")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var waveImageView4: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "musicWave")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var timer = Timer()
    func setup(text: String, index: Int, counter: Int) {
        self.songNameLabel.text = text
        self.songNameLabel.tag = index
//        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] timer  in
//            if index == counter {
//                self?.waveAnimation()
//            } else {
//                self?.resetWaves()
//                timer.invalidate()
//            }
//            
//        }
        if songNameLabel.tag == counter {
            songNameLabel.textColor = .systemOrange
            
        } else {
            songNameLabel.textColor = .black
            timer.invalidate()
        }
    }
    
    func resetWaves() {
        heightConstaint1 = self.waveImageView1.heightAnchor.constraint(equalToConstant: 0)
        heightConstaint2 = self.waveImageView2.heightAnchor.constraint(equalToConstant: 0)
        heightConstaint3 = self.waveImageView3.heightAnchor.constraint(equalToConstant: 0)
        heightConstaint4 = self.waveImageView4.heightAnchor.constraint(equalToConstant: 0)
        heightConstaint1?.isActive = true
        heightConstaint2?.isActive = true
        heightConstaint3?.isActive = true
        heightConstaint4?.isActive = true
    }
    
    private func setupView() {
        self.contentView.backgroundColor = color
        self.contentView.addSubview(self.songNameLabel)
        self.contentView.addSubview(self.albumImageView)
        self.contentView.addSubview(self.waveImageView1)
        self.contentView.addSubview(self.waveImageView2)
        self.contentView.addSubview(self.waveImageView3)
        self.contentView.addSubview(self.waveImageView4)
        heightConstaint1 = self.waveImageView1.heightAnchor.constraint(equalToConstant: 0)
        heightConstaint2 = self.waveImageView2.heightAnchor.constraint(equalToConstant: 0)
        heightConstaint3 = self.waveImageView3.heightAnchor.constraint(equalToConstant: 0)
        heightConstaint4 = self.waveImageView4.heightAnchor.constraint(equalToConstant: 0)
        heightConstaint1?.isActive = true
        heightConstaint2?.isActive = true
        heightConstaint3?.isActive = true
        heightConstaint4?.isActive = true
        NSLayoutConstraint.activate([
        
            self.songNameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.songNameLabel.leftAnchor.constraint(equalTo: self.albumImageView.rightAnchor, constant: 5),
            
            self.albumImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            self.albumImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            self.albumImageView.widthAnchor.constraint(equalTo: self.albumImageView.heightAnchor),
            self.albumImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            self.albumImageView.heightAnchor.constraint(equalToConstant: 50),
            
            self.waveImageView1.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.waveImageView1.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
           
            
            self.waveImageView2.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.waveImageView2.rightAnchor.constraint(equalTo: self.waveImageView1.leftAnchor, constant: -3),
            
        
            self.waveImageView3.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.waveImageView3.rightAnchor.constraint(equalTo: self.waveImageView2.leftAnchor, constant: -3),
           
            
            self.waveImageView4.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.waveImageView4.rightAnchor.constraint(equalTo: self.waveImageView3.leftAnchor, constant: -3),
            self.waveImageView4.leftAnchor.constraint(greaterThanOrEqualTo: self.songNameLabel.rightAnchor, constant: 5),
           
        ])
    }
    
    func waveAnimation() {
        let randomNumber: [CGFloat] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.heightConstaint1?.constant = randomNumber.randomElement()!
            self.heightConstaint2?.constant = randomNumber.randomElement()!
            self.heightConstaint3?.constant = randomNumber.randomElement()!
            self.heightConstaint4?.constant = randomNumber.randomElement()!
            self.heightConstaint1?.constant = randomNumber.randomElement()!
            self.heightConstaint2?.constant = randomNumber.randomElement()!
            self.heightConstaint3?.constant = randomNumber.randomElement()!
            self.heightConstaint4?.constant = randomNumber.randomElement()!
            self.heightConstaint1?.constant = randomNumber.randomElement()!
            self.heightConstaint2?.constant = randomNumber.randomElement()!
            self.heightConstaint3?.constant = randomNumber.randomElement()!
            self.heightConstaint4?.constant = randomNumber.randomElement()!
            self.contentView.layoutIfNeeded()
        } 
        
    }
}
