//
//  SecretVC.swift
//  Plug
//
//  Created by changmin lee on 2018. 12. 20..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit

private extension Collection {
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

private extension MutableCollection where Index == Int {
    mutating func shuffleInPlace() {
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            self.swapAt(i, j)
            
        }
    }
}

class SecretViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var starScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var berrymelon: UIImageView!
    @IBOutlet weak var jake: UIImageView!
    @IBOutlet weak var planetScrollView: UIScrollView!
    
    let numberOfMembers = 5
    
    var isAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.alpha = 0.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let starView = UIView(frame: CGRect(x: 0, y: 0, width: self.starScrollView.frame.size.width, height: self.starScrollView.frame.size.height * 10))
        starView.backgroundColor = UIColor.clear
        let divideHeight:CGFloat = 60.0
        let times:Int = Int(starView.frame.size.height/divideHeight)
        for i in 0...times {
            let y = CGFloat(i) * CGFloat(divideHeight) + CGFloat(arc4random_uniform(UInt32(divideHeight)))
            let x = CGFloat(arc4random_uniform(UInt32(starView.frame.size.width)))
            
            let star = UIImageView(frame: CGRect(x: x, y: y, width: 20, height: 20))
            star.image = UIImage(named: "star_small")!
            star.contentMode = UIViewContentMode.center
            star.backgroundColor = UIColor.clear
            self.twinkle(star)
            starView.addSubview(star)
        }
        
        self.starScrollView.addSubview(starView)
        self.starScrollView.contentSize = CGSize(width: self.starScrollView.frame.size.width, height: starView.frame.size.height)
        self.starScrollView.isUserInteractionEnabled = false
        self.starScrollView.contentOffset = CGPoint(x: 0, y: starView.frame.size.height)
        
        
        let planetView = UIView(frame: CGRect(x: 0, y: 0, width: self.planetScrollView.frame.size.width, height: self.planetScrollView.frame.size.height * 10))
        planetView.backgroundColor = UIColor.clear
        
        let mainPlanetDivideHeight:CGFloat = 100
        let mainPlanetTimes:Int = Int(planetView.frame.size.height/mainPlanetDivideHeight)
        var planetNums = [0,1,2,3,4,5]
        var planetIndex = 0
        var needsShuffle = true
        for i in 0...mainPlanetTimes {
            let yPosition = CGFloat(i) * CGFloat(mainPlanetDivideHeight)
            
            if yPosition > self.tableView.contentSize.height {
                break
            }
            
            let y = yPosition + CGFloat(arc4random_uniform(UInt32(mainPlanetDivideHeight)))
            let leftOrRight = arc4random_uniform(2) % 2 == 0 ? true : false
            let randomX:CGFloat = CGFloat(arc4random_uniform(10) + 50)
            let x = leftOrRight ? -(randomX) : planetView.frame.size.width - (randomX)
            
            if needsShuffle {
                needsShuffle = false
                planetNums = planetNums.shuffle()
            }
            
            let planetNum = planetNums[planetIndex]
            
            let planet = UIImageView(frame: CGRect(x: x, y: y, width: 100, height: 100))
            planet.image = UIImage(named: "planet_\(planetNum)")!
            planet.contentMode = UIViewContentMode.center
            planet.backgroundColor = UIColor.clear
            self.glide(planet)
            planetView.addSubview(planet)
            
            planetIndex += 1
            if planetIndex > planetNums.count - 1 {
                planetIndex = 0
                needsShuffle = true
            }
        }
        
        let planetDivideHeight:CGFloat = 200.0
        let planetTimes:Int = Int(planetView.frame.size.height/planetDivideHeight)
        for i in 0...planetTimes {
            
            let yPosition = CGFloat(i) * CGFloat(planetDivideHeight)
            if yPosition > self.tableView.contentSize.height {
                let y = yPosition + CGFloat(arc4random_uniform(UInt32(planetDivideHeight)))
                let x = CGFloat(arc4random_uniform(UInt32(planetView.frame.size.width)))
                
                let planet = UIImageView(frame: CGRect(x: x, y: y, width: 20, height: 20))
                
                let planetNum = Int(arc4random_uniform(5)) + 1
                planet.image = UIImage(named: "planet_\(planetNum)")!
                planet.contentMode = UIViewContentMode.center
                planet.backgroundColor = UIColor.clear
                planetView.addSubview(planet)
            }
            
        }
        
        let madebyView = UIView(frame: CGRect(x: 0, y: -400, width: self.planetScrollView.frame.size.width, height: 400))
        let madebyPlanet = UIImageView(frame: CGRect(x: 0, y: 8, width: 30, height: 30))
        madebyPlanet.center.x = madebyView.center.x
        madebyPlanet.image = UIImage(named: "moon")
        madebyPlanet.contentMode = UIViewContentMode.center
        madebyView.addSubview(madebyPlanet)
        
        let madebyLabel = UILabel(frame: CGRect(x: 0, y: 60, width: self.planetScrollView.frame.size.width, height: 100))
        madebyLabel.textAlignment = NSTextAlignment.center
        madebyLabel.numberOfLines = 0
        madebyLabel.textColor = UIColor.plugBlue
        madebyLabel.text = "Plug for iOS\n\nMade By\nChang min Lee"
        madebyView.backgroundColor = UIColor.clear
        madebyView.addSubview(madebyLabel)
        
        self.planetScrollView.addSubview(madebyView)
        self.planetScrollView.addSubview(planetView)
        self.planetScrollView.contentSize = CGSize(width: self.planetScrollView.frame.size.width, height: planetView.frame.size.height)
        self.planetScrollView.isUserInteractionEnabled = false
        self.planetScrollView.contentOffset = CGPoint(x: 0, y: planetView.frame.size.height)
        
        
        self.isAnimating = true
        
        var berrymelonFrame = self.berrymelon.frame
        var jakeFrame = self.jake.frame
        
        UIView.animate(withDuration: 4.0, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            self.starScrollView.contentOffset = CGPoint(x: 0.0, y: 0)
            self.planetScrollView.contentOffset = CGPoint(x: 0.0, y: 0)
        }, completion: {(complete) in
            self.isAnimating = false
        })
        
        self.tableView.alpha = 1.0
        self.tableView.contentInset = UIEdgeInsets(top: -self.tableView.frame.size.height * 5, left: 0, bottom: 0, right: 0)
        UIView.animate(withDuration: 2.0, delay: 2.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions(), animations: {
            self.tableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 120, right: 0)
            self.tableView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }, completion: {(complete) in
            
            berrymelonFrame.origin.y -= self.jake.frame.size.height
            jakeFrame.origin.y -= self.jake.frame.size.height
            UIView.animate(withDuration: 1.0, delay: 0.3, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(), animations: {
                self.berrymelon.frame = berrymelonFrame
            }, completion: nil)
            UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(), animations: {
                self.jake.frame = jakeFrame
            }, completion: {(complete) in
                self.berrymelon.isUserInteractionEnabled = true
                self.jake.isUserInteractionEnabled = true
                self.setupDynamics()
            })
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var animator:UIDynamicAnimator? = nil
    var collision: UICollisionBehavior?
    var attach: UIAttachmentBehavior?
    
    fileprivate func setupDynamics() {
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        self.collision = UICollisionBehavior(items: [self.berrymelon,self.jake]);
        self.collision!.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        let panGestureBerry = UIPanGestureRecognizer(target: self, action: #selector(SecretViewController.panGestureTriggered(_:)))
        self.berrymelon.addGestureRecognizer(panGestureBerry)
        
        let panGestureJake = UIPanGestureRecognizer(target: self, action: #selector(SecretViewController.panGestureTriggered(_:)))
        self.jake.addGestureRecognizer(panGestureJake)
        
        self.animator!.addBehavior(self.collision!)
        
    }
    
    @objc dynamic fileprivate func panGestureTriggered(_ gesture:UIPanGestureRecognizer) {
        
        let location = gesture.location(in: self.view);
        let touchLocation = gesture.location(in: gesture.view!);
        
        if gesture.state == UIGestureRecognizerState.began {
            // Do some initial setup here
            // Will set the box's center to the location value stored above
            //self.animator?.removeAllBehaviors()
            
            let offset = UIOffsetMake(touchLocation.x - gesture.view!.bounds.midX, touchLocation.y - gesture.view!.bounds.midY)
            self.attach = UIAttachmentBehavior(item: gesture.view!, offsetFromCenter: offset, attachedToAnchor: location)
            self.animator!.addBehavior(self.attach!);
        }
        else if gesture.state == UIGestureRecognizerState.changed {
            self.attach!.anchorPoint = location;
        } else if gesture.state == UIGestureRecognizerState.ended {
            
            self.animator!.removeBehavior(self.attach!)
            
            let itemBehavior = UIDynamicItemBehavior(items: [gesture.view!]);
            
            let spaceX = gesture.velocity(in: self.view).x / 10
            let spaceY = gesture.velocity(in: self.view).y / 10
            let spaceVelocity = CGPoint(x: spaceX, y: spaceY)
            
            itemBehavior.addLinearVelocity(spaceVelocity, for: gesture.view!);
            itemBehavior.angularResistance = 0.0;
            itemBehavior.elasticity = 1.0;
            itemBehavior.resistance = 0.0;
            self.animator!.addBehavior(itemBehavior);
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfMembers+2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 180.0
        }
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell:SecretTitleCell = tableView.dequeueReusableCell(withIdentifier: "SecretTitleCell", for: indexPath) as! SecretTitleCell
            return cell
        }
        
        if indexPath.row == numberOfMembers+1 {
            let cell:SecretCloseCell = tableView.dequeueReusableCell(withIdentifier: "SecretCloseCell", for: indexPath) as! SecretCloseCell
            return cell
        }
        
        let cell:SecretMainCell = tableView.dequeueReusableCell(withIdentifier: "SecretMainCell", for: indexPath) as! SecretMainCell
        cell.draw(indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == numberOfMembers+1 {
            self.isAnimating = true
            UIView.animate(withDuration: 4.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.starScrollView.contentOffset = CGPoint(x: 0.0, y: self.starScrollView.frame.size.height * 10)
                self.planetScrollView.contentOffset = CGPoint(x: 0.0, y: self.planetScrollView.frame.size.height * 10)
            }, completion: {(complete) in
                self.isAnimating = false
                self.dismiss(animated: true, completion: nil)
            })
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                self.tableView.alpha = 0.0
            }, completion: {(complete) in
                
            })
            
            self.animator?.removeAllBehaviors()
            
            UIView.animate(withDuration: 2.0, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                self.berrymelon.center = CGPoint(x: self.berrymelon.center.x, y: -100)
                self.jake.center = CGPoint(x: self.jake.center.x, y: -100)
            }, completion: {(complete) in
                self.berrymelon.removeFromSuperview()
                self.jake.removeFromSuperview()
            })
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.tableView == scrollView {
            if self.isAnimating { return }
            
            let offset = scrollView.contentOffset.y
            
            let backPercentage:CGFloat = 0.1
            let backCalibOffset = (offset * backPercentage)// + self.starScrollView.frame.size.height
            
            self.starScrollView.contentOffset = CGPoint(x: 0, y: backCalibOffset)
            
            let planetPercentage:CGFloat = 1.2
            let planetCalibOffset = (offset * planetPercentage)// + self.planetScrollView.frame.size.height
            
            self.planetScrollView.contentOffset = CGPoint(x: 0, y: planetCalibOffset)
        }
        
    }
    
    fileprivate func twinkle(_ view:UIView) {
        
        let delay = Double(arc4random_uniform(10)) + 3
        
        UIView.animateKeyframes(withDuration: 3.0, delay: delay, options: [UIViewKeyframeAnimationOptions.autoreverse,UIViewKeyframeAnimationOptions.repeat], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                view.alpha = 0.0
            })
            
        }, completion: nil)
    }
    
    fileprivate func glide(_ view:UIView) {
        
        let direction:CGFloat = view.frame.origin.x < self.view.frame.size.width/2 ? 1 : -1
        
        let originalFrame = view.frame
        var movingFrame = originalFrame
        let randomX = CGFloat(arc4random_uniform(50) + 20)
        movingFrame.origin.x += randomX * direction
        
        let randomDuration = Double(arc4random_uniform(10) + 5)
        UIView.animateKeyframes(withDuration: randomDuration, delay: 0, options: [UIViewKeyframeAnimationOptions.autoreverse,UIViewKeyframeAnimationOptions.repeat], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                view.frame = movingFrame
            })
            
        }, completion: nil)
        
    }
    
}

class SecretTitleCell:UITableViewCell {
    
}

class SecretCloseCell:UITableViewCell {
    
}

class SecretMainCell:UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func draw(_ index:Int) {
        
        nameLabel.alpha = 0.0
        descriptionLabel.alpha = 0.0
        
        let title = kMembers[index - 1]
        let description = kCredits[index - 1]
        nameLabel.text = NSLocalizedString(title,comment:"")
        descriptionLabel.text = NSLocalizedString(description,comment:"")
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.nameLabel.alpha = 1.0
            self.descriptionLabel.alpha = 1.0
            
        })
    }
    
}
