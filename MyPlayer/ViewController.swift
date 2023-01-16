//
//  ViewController.swift
//  MyPlayer
//
//  Created by ROMAN VRONSKY on 06.01.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let download = DownloadManager.shared
    var counter = 0
    let songs = ["Queen","Just The Two Of Us","09 We Like Songs","Chet Faker  - No Diggity Live Sessions","All I Do (Todd Terje Edit)"]
    var tracks: [String] {
        let array = (try? FileManager.default.contentsOfDirectory(atPath: path.path())) ?? []
        return array
    }
    var showingBackView = false
    
    let color = #colorLiteral(red: 0.9296384454, green: 0.9451069236, blue: 0.9368827939, alpha: 1)
    
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    private lazy var containerButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = true
        return view
    }()
    private lazy var tableViewBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = true
        return view
    }()
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var songsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SongsTableViewCell.self, forCellReuseIdentifier: "songsCell")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var buttonBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.7342417836, green: 0.7921757102, blue: 0.7716051936, alpha: 1)
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
        self.setupView()
        self.gestureView()
        musicSlider.value = 0.0
        
        MusicNetworkManager.shared.loadMusic {[weak self] music in
            let group = DispatchGroup()
            group.enter()
            DispatchQueue.global().async {
                self?.url = music ?? ""
                group.leave()
            }
            group.notify(queue: .main)  {
                self?.download.download(url: self!.url) { trackUrl in
                    DispatchQueue.main.async {
                        self?.track = trackUrl
                        self?.music()
                    }
                    
                }
            }
        }
        print(tracks)
        print(path)
        
    }
    
    
    var botomContainerConstraint: NSLayoutConstraint?
    var botomSliderConstraint: NSLayoutConstraint?
    var url = ""
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.containerView)
        self.view.addSubview(self.containerButtonView)
        self.containerButtonView.addSubview(self.buttonBackgroundView)
        self.containerView.addSubview(self.tableViewBackgroundView)
        self.tableViewBackgroundView.addSubview(self.songsTableView)
        self.containerView.addSubview(self.backgroundView)
        self.buttonBackgroundView.addSubview(self.musicSlider)
        self.buttonBackgroundView.addSubview(self.pauseButton)
        self.buttonBackgroundView.addSubview(self.nextButton)
        self.buttonBackgroundView.addSubview(self.backButton)
        self.buttonBackgroundView.addSubview(self.playButton)
        self.view.bringSubviewToFront(backgroundView)
        botomContainerConstraint = self.containerView.bottomAnchor.constraint(equalTo: self.containerButtonView.topAnchor, constant: 20)
        botomSliderConstraint =  self.musicSlider.bottomAnchor.constraint(equalTo: self.buttonBackgroundView.bottomAnchor, constant: -20)
        botomContainerConstraint?.isActive = true
        botomSliderConstraint?.isActive = true
        //        self.backgroundView.addSubview(self.songNameLabel)
        //        self.backgroundView.addSubview(self.songTimeLabel)
        //        self.backgroundView.addSubview(self.albumImageView)
        //        self.backgroundView.addSubview(self.stopButton)
        
        
        NSLayoutConstraint.activate([
            
            
            self.containerButtonView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30 ),
            self.containerButtonView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.containerButtonView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            self.containerButtonView.heightAnchor.constraint(equalToConstant: 90),
            
            self.containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            //            self.containerView.bottomAnchor.constraint(equalTo: self.containerButtonView.topAnchor, constant: 20),
            self.containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            
            
            self.backgroundView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.backgroundView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            self.backgroundView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor),
            
            self.buttonBackgroundView.bottomAnchor.constraint(equalTo: self.containerButtonView.bottomAnchor, constant: -10),
            self.buttonBackgroundView.leftAnchor.constraint(equalTo: self.containerButtonView.leftAnchor, constant: 10),
            self.buttonBackgroundView.rightAnchor.constraint(equalTo: self.containerButtonView.rightAnchor, constant: -10),
            self.buttonBackgroundView.heightAnchor.constraint(equalToConstant: 150),
            
            
            self.playButton.centerXAnchor.constraint(equalTo: self.buttonBackgroundView.centerXAnchor),
            self.playButton.bottomAnchor.constraint(equalTo: self.buttonBackgroundView.bottomAnchor, constant: -50),
            self.playButton.heightAnchor.constraint(equalToConstant: 50),
            self.playButton.widthAnchor.constraint(equalToConstant: 50),
            
            
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
            
            self.tableViewBackgroundView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.tableViewBackgroundView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.tableViewBackgroundView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            self.tableViewBackgroundView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor),
            
            self.songsTableView.topAnchor.constraint(equalTo: self.tableViewBackgroundView.topAnchor, constant: 5),
            self.songsTableView.bottomAnchor.constraint(equalTo: self.tableViewBackgroundView.bottomAnchor, constant: -5),
            self.songsTableView.rightAnchor.constraint(equalTo: self.tableViewBackgroundView.rightAnchor, constant: -5),
            self.songsTableView.leftAnchor.constraint(equalTo: self.tableViewBackgroundView.leftAnchor, constant: 5),
            
        ])
    }
    
    
    private func gestureView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(flip))
        gesture.numberOfTapsRequired = 1
        self.backgroundView.addGestureRecognizer(gesture)
        
    }
    
    @objc private func flip() {
        //        self.view.layoutIfNeeded()
        let delay = showingBackView ? 1 : 0
        let viewCentr = self.buttonBackgroundView.frame.origin.y
        let buttonsBoundsY = self.buttonBackgroundView.bounds.origin.y
        let buttonsBoundsX = self.buttonBackgroundView.bounds.origin.x
        let buttonsHieght = self.buttonBackgroundView.frame.height / 2
        let down = buttonsBoundsX + buttonsHieght
        let toView = showingBackView ? self.backgroundView : self.tableViewBackgroundView
        let fromView = showingBackView ?  self.tableViewBackgroundView : self.backgroundView
        UIView.animateKeyframes(withDuration: 0.3, delay: TimeInterval(delay), options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.playButton.transform = self.showingBackView ? .identity : CGAffineTransform(scaleX: 1, y: 2)
                self.nextButton.transform = self.showingBackView ? .identity : CGAffineTransform(scaleX: 1, y: 2)
                self.backButton.transform = self.showingBackView ? .identity : CGAffineTransform(scaleX: 1, y: 2)
                self.pauseButton.transform = self.showingBackView ? .identity : CGAffineTransform(scaleX: 1, y: 2)
                self.musicSlider.transform = self.showingBackView ? .identity : CGAffineTransform(scaleX: 1, y: 2)
                self.buttonBackgroundView.transform = self.showingBackView ? .identity : CGAffineTransform(scaleX: 1, y: 0.5)
                self.buttonBackgroundView.backgroundColor = self.showingBackView ?  #colorLiteral(red: 0.7342417836, green: 0.7921757102, blue: 0.7716051936, alpha: 1) : .clear
                self.botomSliderConstraint?.constant = self.showingBackView ? -20 : 0
                self.botomContainerConstraint?.constant = self.showingBackView ? 20 : -10
                
                self.buttonBackgroundView.center = self.showingBackView ? CGPoint(x: self.containerButtonView.bounds.midX, y: viewCentr) : CGPoint(x: self.containerButtonView.bounds.midX, y: self.containerButtonView.bounds.maxY - 45)
                self.view.layoutIfNeeded()
            }
        }
        UIView.transition(from: fromView, to: toView, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews] ) {_ in
            
            self.showingBackView.toggle()
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    
    var track: URL?
    private func music() {
        //        let trackName = "myTrack"
        //        let urlTrack = path.appending(path: trackName)
        //        URL.init(fileURLWithPath: Bundle.main.path(forResource: "\(songs[counter])", ofType: "mp3")!
        
        print("🍓\(counter)")
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path() + tracks[counter]
        print(url)
        guard let trackURL = URL(string: url) else {return}
        do {
            player = try AVAudioPlayer(contentsOf: trackURL, fileTypeHint: "mp3")
            player.prepareToPlay()
        }
        catch {
            print(error)
        }
        //        self.albumImageView.image = albums.randomElement()!!
    }
    
    @objc func nextSong() {
        if (self.counter + 1) == tracks.count {
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
        music()
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
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songsCell", for: indexPath) as! SongsTableViewCell
        cell.setup(text: tracks[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flip()
    }
}


/*
 class MyViewController: UIViewController {
 
 @IBOutlet weak var containerView: UIView!
 
 private let backImageView: UIImageView! = UIImageView(image: UIImage(named: "back"))
 private let frontImageView: UIImageView! = UIImageView(image: UIImage(named: "front"))
 
 private var showingBack = false
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 frontImageView.contentMode = .ScaleAspectFit
 backImageView.contentMode = .ScaleAspectFit
 
 containerView.addSubview(frontImageView)
 frontImageView.translatesAutoresizingMaskIntoConstraints = false
 frontImageView.spanSuperview()
 
 let singleTap = UITapGestureRecognizer(target: self, action: #selector(flip))
 singleTap.numberOfTapsRequired = 1
 containerView.addGestureRecognizer(singleTap)
 }
 
 func flip() {
 let toView = showingBack ? frontImageView : backImageView
 let fromView = showingBack ? backImageView : frontImageView
 UIView.transitionFromView(fromView, toView: toView, duration: 1, options: .TransitionFlipFromRight, completion: nil)
 toView.translatesAutoresizingMaskIntoConstraints = false
 toView.spanSuperview()
 showingBack = !showingBack
 }
 
 }
 */
