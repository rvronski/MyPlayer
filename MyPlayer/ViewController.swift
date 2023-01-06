//
//  ViewController.swift
//  MyPlayer
//
//  Created by ROMAN VRONSKY on 06.01.2023.
//

import UIKit

class ViewController: UIViewController {
//    let tabBar = CustomTabBarViewController()
    
    let color = #colorLiteral(red: 0.2783567309, green: 0.4328829646, blue: 0.384449482, alpha: 1)
    private lazy var backgroundView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color.withAlphaComponent(0.2)
        view.layer.cornerRadius = 15
        return view
    }()
    private lazy var songNameLabel: UILabel = {
        let songNameLabel = UILabel()
        songNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return songNameLabel
    }()
    
    private lazy var songTimeLabel: UILabel = {
        let songTimeLabel = UILabel()
        songTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        return songTimeLabel
    }()
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var musicSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.translatesAutoresizingMaskIntoConstraints = false
//        slider.addTarget(self, action: #selector(touchSlider), for: .valueChanged)
        return slider
    }()
    
    private lazy var playButton: UIButton = {
        let playButton = UIButton()
        playButton.clipsToBounds = true
        let image = UIImage.SymbolConfiguration(pointSize: 25, weight: .heavy, scale: .large)
        playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: image), for: .normal)
       
        playButton.clipsToBounds = true
        playButton.translatesAutoresizingMaskIntoConstraints = false
//        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        return playButton
    }()
    
    private lazy var stopButton: UIButton = {
        let stopButton = UIButton()
        stopButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
//        stopButton.addTarget(self, action: #selector(stop), for: .touchUpInside)
        return stopButton
    }()
    
    private lazy var pauseButton: UIButton = {
        let pauseButton = UIButton()
        pauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.isHidden = true
//        pauseButton.addTarget(self, action: #selector(pause), for: .touchUpInside)
        return pauseButton
    }()
    
    private lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
//        nextButton.addTarget(self, action: #selector(nextSong), for: .touchUpInside)
        return nextButton
    }()
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
//        backButton.addTarget(self, action: #selector(backSong), for: .touchUpInside)
        return backButton
    }()
    
//    var player = AVAudioPlayer()
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.backgroundView)
        self.backgroundView.addSubview(self.playButton)
//        self.backgroundView.addSubview(self.songNameLabel)
//        self.backgroundView.addSubview(self.songTimeLabel)
//        self.backgroundView.addSubview(self.albumImageView)
//        self.backgroundView.addSubview(self.musicSlider)
//        self.backgroundView.addSubview(self.stopButton)
//        self.backgroundView.addSubview(self.pauseButton)
//        self.backgroundView.addSubview(self.nextButton)
//        self.backgroundView.addSubview(self.backButton)
        
//        let tabBarHieght = tabBar.layerHeight
        NSLayoutConstraint.activate([
            
            self.backgroundView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.backgroundView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30 ),
            self.backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            
            self.playButton.centerXAnchor.constraint(equalTo: self.backgroundView.centerXAnchor),
            self.playButton.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: -50),
            self.playButton.heightAnchor.constraint(equalToConstant: 50),
            self.playButton.widthAnchor.constraint(equalToConstant: 50),
            
        
        ])
    }
}

