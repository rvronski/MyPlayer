//
//  CustomTabBar.swift
//  MyPlayer
//
//  Created by ROMAN VRONSKY on 06.01.2023.
//

import UIKit

struct Option {
    var name:String
    var image:UIImage
}

class CustomTabBarViewController: UITabBarController, UITabBarControllerDelegate {
//    let height = self.tabBar.bounds.height + 20 * 1.5
    var layerHeight = CGFloat()
    private var buttonIsTapped = false
    private lazy var middleButton: UIButton = {
        let button = UIButton()
        let image = UIImage.SymbolConfiguration(pointSize: 15, weight: .heavy, scale: .large)
        button.setImage(UIImage(systemName: "plus", withConfiguration: image), for: .normal)
        button.imageView?.tintColor = .white
        button.backgroundColor = .systemOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    
    private var index = Int()
    private var optionButton = [UIButton]()
    private var options = [Option(name: "A", image: UIImage(systemName: "person") ?? UIImage()),
                           Option(name: "B", image: UIImage(systemName: "person") ?? UIImage()),
                           Option(name: "C", image: UIImage(systemName: "person") ?? UIImage())]
    
    override func viewDidLoad() {
        self.setupTabBar()
    }
    
    func setupTabBar() {
        let layer = CAShapeLayer()
        
       
        let firstVC = UINavigationController(rootViewController: ViewController())
        let secondVC = UINavigationController(rootViewController: SecondViewController())
        let thirdVC = UINavigationController(rootViewController: ThirdViewController())
        self.viewControllers = [firstVC, secondVC, thirdVC]
        let itemsImage = ["house", "plus", "person"]
        let selectedImage = ["house.fill", "plus.circle.fill", "person.fill"]
        guard let items = self.tabBar.items else {return}
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: itemsImage[i])
            items[i].selectedImage = UIImage(systemName: selectedImage[i])
        }
        
        let x: CGFloat = 10
        let y: CGFloat = 20
        
        let width = self.tabBar.bounds.width - x * 2
        let height = self.tabBar.bounds.height + y * 1.5
        layerHeight = height
        layer.fillColor = #colorLiteral(red: 0.2936886549, green: 0.4803959727, blue: 0.4528408051, alpha: 0.8600324416)
//        UIColor.black.cgColor
        layer.path = UIBezierPath(roundedRect: CGRect(x: x,
                                              y: self.tabBar.bounds.minY - y,
                                              width: width,
                                              height: height),
                                  cornerRadius: height / 2).cgPath
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1
        
        self.tabBar.layer.insertSublayer(layer, at: 0)
        self.tabBar.tintColor = .orange
        self.tabBar.itemWidth = width/6
        self.tabBar.itemPositioning = .centered
        self.tabBar.unselectedItemTintColor = .white
//        #colorLiteral(red: 0.8919453621, green: 0.4421625409, blue: 0.6338356567, alpha: 1)
        addMiddleButton()
    }
    
    private func addMiddleButton() {
        
        DispatchQueue.main.async {
            if let items = self.tabBar.items {
                items[1].isEnabled = false
            }
        }
        self.tabBar.addSubview(self.middleButton)
        let size = CGFloat(50)
        let constant: CGFloat = -20 + (layerHeight / 2) - 5
        
        NSLayoutConstraint.activate([
            self.middleButton.centerXAnchor.constraint(equalTo: self.tabBar.centerXAnchor),
            self.middleButton.centerYAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: constant),
            self.middleButton.heightAnchor.constraint(equalToConstant: size),
            self.middleButton.widthAnchor.constraint(equalToConstant: size)


        ])
        
        self.middleButton.layer.cornerRadius = size / 2
        self.middleButton.addTarget(self, action: #selector(middleButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func middleButtonDidTap() {
        if buttonIsTapped == false {
            UIView.animate(withDuration: 0.3) {
                self.middleButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
                self.middleButton.backgroundColor = .white
                self.middleButton.imageView?.tintColor = #colorLiteral(red: 0.8927060366, green: 0.8517331481, blue: 0.6561288834, alpha: 1)
                self.middleButton.layer.borderWidth = 5
                self.middleButton.layer.borderColor = #colorLiteral(red: 0.8927060366, green: 0.8517331481, blue: 0.6561288834, alpha: 1)
                self.buttonIsTapped = true
                self.setUpButtons(count: self.options.count, center: self.middleButton, radius: 80)
                
            }
            
        } else {
            UIView.animate(withDuration: 0.15) { [weak self] in
                self?.middleButton.transform = CGAffineTransform(rotationAngle: 0)
                self?.middleButton.backgroundColor = .systemOrange
                self?.middleButton.layer.borderWidth = 0
                self?.middleButton.imageView?.tintColor = .white
                self?.buttonIsTapped = false
                self?.removeButtons()
            }
        }
    }
    
    private func createButton(size: CGFloat) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = #colorLiteral(red: 0.8933888078, green: 0.4429260492, blue: 0.6345424056, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.bottomAnchor.constraint(equalTo: self.middleButton.topAnchor, constant: 16).isActive = true
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.layer.cornerRadius = size / 2
        
        if buttonIsTapped == true {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut) {
                button.imageView?.tintColor = .clear
                button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { _ in
                button.imageView?.tintColor = .white
                button.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        return button
    }
    
    private func ctraeteBackground() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.titleLabel?.text = ""
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
    
        return button
        
    }
    
    @objc func backgroundPressed(sender: UIButton) {
        if buttonIsTapped == true {
            middleButton.sendActions(for: .touchUpInside)
        } else {
            sender.isUserInteractionEnabled = false
            sender.removeFromSuperview() }
        
    }
    
    func setUpButtons(count: Int, center: UIView, radius: CGFloat) {
            
            // set buttons distance using degrees
            let degrees = 135 / CGFloat(count)
            
            // create background to avoid other interactions
            let background = ctraeteBackground()
            background.addTarget(self, action: #selector(backgroundPressed(sender:)), for: .touchUpInside)
            background.addTarget(self, action: #selector(backgroundPressed(sender:)), for: .touchDragInside)
            self.optionButton.append(background)
            
            // set middle button to be in front
            tabBar.bringSubviewToFront(middleButton)
            
            // create three buttons
            for i in 0 ..< count {
                
                // set index to assign action
                self.index = i
                
                // create and set the buttons
                let button = createButton(size: 44)
                self.optionButton.append(button)
                self.view.addSubview(button)
                button.imageView?.isHidden = false
                
                // set constraints using trigonometry
                let x = cos(degrees * CGFloat(i+1) * .pi/180) * radius
                let y = sin(degrees * CGFloat(i+1) * .pi/180) * radius
                button.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor, constant: -x).isActive = true
                button.centerYAnchor.constraint(equalTo: center.centerYAnchor, constant: -y).isActive = true
                
                // final setup
                button.setImage(options[i].image, for: .normal)
                self.view.bringSubviewToFront(button)
                button.addTarget(self, action: #selector(optionHandler(sender:)), for: .touchUpInside)
            }
        }


        @objc func optionHandler(sender: UIButton) {
            
            switch index {
                
            case 0: print("Button 1 was pressed.")
            case 1: print("Button 2 was pressed.")
            default: print("Button 3 was pressed.")
                
            }
        }
    
    func removeButtons() {
            
            for button in self.optionButton {
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                    button.transform = CGAffineTransform(scaleX: 1.15, y: 1.1)
                }, completion: { _ in
                    button.alpha = 0
                    if button.alpha == 0 {
                        button.removeFromSuperview()
                    }
                })
            }
        }
}

//#colorLiteral(red: 1, green: 0.8409774303, blue: 0.8370974064, alpha: 1)

