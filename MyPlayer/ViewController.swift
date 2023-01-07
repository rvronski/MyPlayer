//
//  ViewController.swift
//  MyPlayer
//
//  Created by ROMAN VRONSKY on 06.01.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var counter = 0
    let songs = ["Queen","Just The Two Of Us","09 We Like Songs","Chet Faker  - No Diggity Live Sessions","All I Do (Todd Terje Edit)"]
    
    let color = #colorLiteral(red: 0.2783567309, green: 0.4328829646, blue: 0.384449482, alpha: 1)
    
    private lazy var backgroundView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color.withAlphaComponent(0.1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var buttonBackgroundView: UIView = {
        let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.backgroundColor = color.withAlphaComponent(0.3)
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
        slider.maximumTrackTintColor = color
        slider.minimumTrackTintColor = .orange
        let image = UIImage.SymbolConfiguration(pointSize: 2, weight: .ultraLight, scale: .small )
        slider.setThumbImage(UIImage(systemName: "circle.dotted",withConfiguration: image), for: .normal)
       
//        slider.thumbTintColor = .black
        slider.minimumValue = 0.0
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(touchSlider), for: .valueChanged)
        return slider
    }()
    
    private lazy var playButton: UIButton = {
        let playButton = UIButton()
        playButton.clipsToBounds = true
        let image = UIImage.SymbolConfiguration(pointSize: 25, weight: .heavy, scale: .large)
        playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: image), for: .normal)
        playButton.clipsToBounds = true
        playButton.tintColor = #colorLiteral(red: 0.2936886549, green: 0.4803959727, blue: 0.4528408051, alpha: 0.8600324416)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
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
        let image = UIImage.SymbolConfiguration(pointSize: 25, weight: .heavy, scale: .large)
        pauseButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: image), for: .normal)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.isHidden = true
        pauseButton.tintColor = #colorLiteral(red: 0.2936886549, green: 0.4803959727, blue: 0.4528408051, alpha: 0.8600324416)
        pauseButton.addTarget(self, action: #selector(pause), for: .touchUpInside)
        return pauseButton
    }()
    
    private lazy var nextButton: UIButton = {
        let nextButton = UIButton()
        nextButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.tintColor = #colorLiteral(red: 0.2936886549, green: 0.4803959727, blue: 0.4528408051, alpha: 0.8600324416)
        nextButton.addTarget(self, action: #selector(nextSong), for: .touchUpInside)
        return nextButton
    }()
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.tintColor = #colorLiteral(red: 0.2936886549, green: 0.4803959727, blue: 0.4528408051, alpha: 0.8600324416)
        backButton.addTarget(self, action: #selector(backSong), for: .touchUpInside)
        return backButton
    }()
    
    var player = AVAudioPlayer()
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        music()
        musicSlider.value = 0.0
        MusicNetworkManager.loadMusic { track in
            DispatchQueue.main.async {
                print(track)
            }
        }
        
    }

    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.backgroundView)
        self.backgroundView.addSubview(self.buttonBackgroundView)
        self.buttonBackgroundView.addSubview(self.musicSlider)
        self.buttonBackgroundView.addSubview(self.pauseButton)
        self.buttonBackgroundView.addSubview(self.nextButton)
        self.buttonBackgroundView.addSubview(self.backButton)
        self.buttonBackgroundView.addSubview(self.playButton)
//        self.backgroundView.addSubview(self.songNameLabel)
//        self.backgroundView.addSubview(self.songTimeLabel)
//        self.backgroundView.addSubview(self.albumImageView)
//        self.backgroundView.addSubview(self.stopButton)
        
       
        NSLayoutConstraint.activate([
            
            self.backgroundView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.backgroundView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30 ),
            self.backgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.backgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            
            self.buttonBackgroundView.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: -10),
            self.buttonBackgroundView.leftAnchor.constraint(equalTo: self.backgroundView.leftAnchor, constant: 10),
            self.buttonBackgroundView.rightAnchor.constraint(equalTo: self.backgroundView.rightAnchor, constant: -10),
            self.buttonBackgroundView.heightAnchor.constraint(equalToConstant: 150),
            
            
            self.playButton.centerXAnchor.constraint(equalTo: self.buttonBackgroundView.centerXAnchor),
            self.playButton.bottomAnchor.constraint(equalTo: self.buttonBackgroundView.bottomAnchor, constant: -50),
            self.playButton.heightAnchor.constraint(equalToConstant: 50),
            self.playButton.widthAnchor.constraint(equalToConstant: 50),
            
            self.musicSlider.bottomAnchor.constraint(equalTo: self.buttonBackgroundView.bottomAnchor, constant: -20),
            self.musicSlider.leftAnchor.constraint(equalTo: self.buttonBackgroundView.leftAnchor, constant: 10),
            self.musicSlider.rightAnchor.constraint(equalTo: self.buttonBackgroundView.rightAnchor, constant: -10),
            
            self.pauseButton.centerXAnchor.constraint(equalTo: self.buttonBackgroundView.centerXAnchor),
            self.pauseButton.bottomAnchor.constraint(equalTo: self.buttonBackgroundView.bottomAnchor, constant: -50),
            self.pauseButton.heightAnchor.constraint(equalToConstant: 50),
            self.pauseButton.widthAnchor.constraint(equalToConstant: 50),
            
            self.nextButton.centerYAnchor.constraint(equalTo: self.playButton.centerYAnchor),
            self.nextButton.leftAnchor.constraint(equalTo: self.playButton.rightAnchor, constant: 50),
            self.nextButton.heightAnchor.constraint(equalToConstant: 50),
            self.nextButton.widthAnchor.constraint(equalToConstant: 50),
            
            self.backButton.centerYAnchor.constraint(equalTo: self.playButton.centerYAnchor),
            self.backButton.rightAnchor.constraint(equalTo: self.playButton.leftAnchor, constant: -50),
            self.backButton.heightAnchor.constraint(equalToConstant: 50),
            self.backButton.widthAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    private func music() {
        do {
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "\(songs[counter])", ofType: "mp3")!))
            player.prepareToPlay()
        }
        catch {
            print(error)
        }
//        self.albumImageView.image = albums.randomElement()!!
    }
    
    @objc func nextSong() {
        if (self.counter + 1) == songs.count {
            self.counter = -1
        }
        self.counter += 1
        music()
        play()
        player.currentTime = 0
        
    }
    
    
    
    @objc func backSong() {
        if counter > 0 {
            self.counter -= 1
            music()
            play()
            player.currentTime = 0
        } else {
//            stop()
            play()
            return
        }
    }
    
    @objc func pause() {
        player.pause()
        self.playButton.isHidden.toggle()
        self.pauseButton.isHidden.toggle()
    }
    
    @objc func play() {
        musicSlider.maximumValue = Float(player.duration)
        songNameLabel.text = songs[counter]
        if player.isPlaying {
            self.playButton.isHidden = true
            self.pauseButton.isHidden = false
        } else {
            player.play()
            self.playButton.isHidden = true
            self.pauseButton.isHidden = false
            timer = Timer.scheduledTimer(
                withTimeInterval: 0.05,
                repeats: true
            ) { [weak self] timer in
                self?.updateMusicSlider()
            }
            timer.fire()
        }
    }
    
    @objc func touchSlider() {
        player.currentTime = TimeInterval(musicSlider.value)
    }
    
    @objc func updateMusicSlider() {
        musicSlider.value = Float(player.currentTime)
        let songTime = Int(player.duration) - Int(player.currentTime)
        let minutes = String(songTime / 60)
        let seconds = String(songTime % 60)
        self.songTimeLabel.text = minutes + ":" + seconds
        
    }
}

