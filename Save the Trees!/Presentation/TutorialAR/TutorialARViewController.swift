//
//  TutorialARViewController.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 20/07/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import UIKit

class TutorialARViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var tutorialText: [NSMutableAttributedString] = []
    
    var images = [#imageLiteral(resourceName: "tree"), #imageLiteral(resourceName: "magic"), #imageLiteral(resourceName: "flame 1"), #imageLiteral(resourceName: "tree")]
    var handImageView:UIImageView!
    var chainsawView:UIImageView!
    var imagesView = [UIImageView(), UIImageView(), UIImageView(), UIImageView()]
    
    var counterClock = 0
    var counterLabel:UILabel!
    
    var shouldAnimateTap:Bool = true
    
    var inTransition = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Primeira mensagem
        let message1 = lightAttributedString(text: NSLocalizedString("Every minute ", comment: "Every minute "))
        message1.append(boldAttributedString(text: NSLocalizedString("2000 trees ", comment: "2000 trees ")))
        message1.append(lightAttributedString(text: NSLocalizedString("are deforested in the Amazon Forest", comment: "are deforested in the Amazon Forest")))
        
        // Segunda mensagem
        let message2 = lightAttributedString(text: NSLocalizedString("Now you have the ", comment: "Now you have the "))
        message2.append(boldAttributedString(text: NSLocalizedString("magical power ", comment: "magical power ")))
        message2.append(lightAttributedString(text: NSLocalizedString("to make the difference", comment: "to make the difference")))
        
        // Terceira mensagem
        let message3 = lightAttributedString(text: NSLocalizedString("Move your device to make the ", comment: "Move your device to make the "))
        message3.append(boldAttributedString(text: NSLocalizedString("cloud stand above the fire tree", comment: "cloud stand above the fire tree")))
        message3.append(lightAttributedString(text: NSLocalizedString(", then ", comment: ", then ")))
        message3.append(boldAttributedString(text: NSLocalizedString("hold a tap to make it rain", comment: "hold a tap to make it rain")))
        
        let message4 = lightAttributedString(text: NSLocalizedString("You have ", comment: "You have "))
        message4.append(boldAttributedString(text: NSLocalizedString("one minute\nGood luck!", comment: "one minute\nGood luck!")))
        
        self.tutorialText.append(message1)
        self.tutorialText.append(message2)
        self.tutorialText.append(message3)
        self.tutorialText.append(message4)
        
        self.pageControl.numberOfPages = tutorialText.count
        self.playButton.alpha = 0
        self.backButton.alpha = 0
        
        self.setupScrollView()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        switch self.pageControl.currentPage {
        case 0:
            
            if !inTransition {
                self.inTransition = true
                UIView.transition(with: self.imagesView[self.pageControl.currentPage], duration: 0.6, options: .transitionCrossDissolve, animations: {
                    self.imagesView[self.pageControl.currentPage].image = UIImage(named: "firedTree")
                }, completion: { (_) in
                    
                    UIView.animate(withDuration:0.5, animations: { () -> Void in
                        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x + self.scrollView.frame.width, y: self.scrollView.contentOffset.y), animated: true)
                    }) { (finished) -> Void in
                        self.inTransition = false
                    }
                    
                    
                    
                    
                })
            }
            
            
            
        default:
            if !inTransition {
                inTransition = true
                UIView.animate(withDuration:0.5, animations: { () -> Void in
                    self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x + self.scrollView.frame.width, y: self.scrollView.contentOffset.y), animated: true)
                }) { (finished) -> Void in
                    self.inTransition = false
                }
            }
        }
        
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if !inTransition {
            inTransition = true
            UIView.animate(withDuration:0.5, animations: { () -> Void in
                self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x - self.scrollView.frame.width, y: self.scrollView.contentOffset.y), animated: true)
            }) { (finished) -> Void in
                self.inTransition = false
            }
        }
    }
    
    func lightAttributedString(text: String) -> NSMutableAttributedString {
        let helvetica17light = UIFont(name: FONT, size: 17.0)!
        let attributesHelvetica17 = [NSAttributedStringKey.font: helvetica17light]
        
        return NSMutableAttributedString(string: text, attributes: attributesHelvetica17)
    }
    
    func boldAttributedString(text: String) -> NSMutableAttributedString {
        let helvetica17bold = UIFont(name: FONT_BOLD, size: 17.0)!
        let attributes17bold = [NSAttributedStringKey.font: helvetica17bold]
        
        return NSMutableAttributedString(string: text, attributes: attributes17bold)
    }
    
    fileprivate func setupThirdView() {
        //Third view
        handImageView = UIImageView(image: #imageLiteral(resourceName: "mao"))
        handImageView.frame.size = CGSize(width: view.frame.size.width/4, height: view.frame.size.width/4)
        handImageView.center = CGPoint(x: self.imagesView[2].center.x, y: 200)
        
        
        self.imagesView[2].frame.size = CGSize(width: view.frame.size.width/4, height: view.frame.size.width/4)
        self.imagesView[2].center.x = 2*view.frame.size.width + view.frame.size.width*3/4
        
        self.chainsawView = UIImageView(image: #imageLiteral(resourceName: "chainsaw 1"))
        self.chainsawView.frame.size = CGSize(width: view.frame.size.width/4, height: view.frame.size.width/4)
        self.chainsawView.center = CGPoint(x: 2*view.frame.size.width + view.frame.size.width/4, y: self.imagesView[2].center.y)
        
//        self.scrollView.addSubview(self.chainsawView)
//        self.scrollView.addSubview(handImageView)
    }
    
    fileprivate func setupFourthView() {
        //Fourth view
        self.counterLabel = UILabel(frame: CGRect(x: self.view.frame.width*7/2, y: self.view.frame.height/2, width: self.view.frame.width*0.8, height: self.view.frame.height))
        self.counterLabel.center = self.imagesView[3].center
        self.counterLabel.textAlignment = .center
        self.counterLabel.textColor = UIColor.white
        self.counterLabel.text = "\(0)" + NSLocalizedString(" seconds", comment: " seconds")
        self.counterLabel.numberOfLines = 1
        self.counterLabel.font = self.counterLabel.font.withSize(50)
        self.counterLabel.adjustsFontSizeToFitWidth = true
        self.scrollView.addSubview(self.counterLabel)
        
        self.imagesView[3].image = nil
    }
    
    func setupScrollView() {
        //Add all pages in scrollView
        
        var index = 0
        for text in tutorialText {
            let label = UILabel(frame: CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: self.view.frame.width*0.8, height: self.view.frame.height))
            
            label.center = CGPoint(x: view.center.x, y:view.frame.height * CGFloat(3)/CGFloat(4))
            label.textAlignment = .center
            label.attributedText = text
            label.numberOfLines = 0
            label.textColor = UIColor.white
            label.frame = (label.frame.offsetBy(dx: scrollView.contentSize.width, dy: 0))
            
            self.imagesView[index] = UIImageView(image: images[index])
            self.imagesView[index].frame.size = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
            self.imagesView[index].center = view.center
            
            self.imagesView[index].frame = (self.imagesView[index].frame.offsetBy(dx: scrollView.contentSize.width, dy: 0))
            
            
            scrollView.addSubview(label)
            scrollView.addSubview(self.imagesView[index])
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width + self.view.frame.width, height: label.frame.height)
            
            index += 1
            
        }
        
        //Second View
        self.rotateView(targetView: self.imagesView[1])
        
        setupThirdView()
        setupFourthView()
        
    }
    
    private func rotateView(targetView: UIView, duration: Double = 1.0) {
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: -.pi/2)
            
            
        }) { finished in
            
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
                targetView.transform = CGAffineTransform(rotationAngle: .pi/2)
            }) { _ in
                self.rotateView(targetView: targetView, duration: duration)
                
            }
        }
    }
    
    func animateTap() {
//        inTransition = true
//        UIView.animate(withDuration: 1, delay: 0.0, options: .curveLinear, animations: {
//            self.handImageView.center = CGPoint(x:self.imagesView[2].center.x, y:self.imagesView[2].center.y + 50)
//        }) { _ in
//
//            self.imagesView[2].alpha = 0.5
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
//                self.handImageView.center = CGPoint(x:self.imagesView[2].center.x - 100, y:self.imagesView[2].center.y + 50)
//            }) { _ in
//
//                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
//                    self.handImageView.center = CGPoint(x:self.imagesView[2].center.x, y:self.imagesView[2].center.y + 50)
//                }) { _ in
//                    self.imagesView[2].alpha = 0
//
//                    UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveLinear, animations: {
//                        self.handImageView.center = CGPoint(x:self.chainsawView.center.x, y:self.chainsawView.center.y + 50)
//                    }) { _ in
//                        self.chainsawView.alpha = 0.5
//
//                        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
//                            self.handImageView.center = CGPoint(x:self.chainsawView.center.x + 100, y:self.chainsawView.center.y + 50)
//                        }) { _ in
//                            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
//                                self.handImageView.center = CGPoint(x:self.chainsawView.center.x, y:self.chainsawView.center.y + 50)
//                            }) { _ in
//                                self.chainsawView.alpha = 0
//                                self.shouldAnimateTap = false
//                                self.inTransition = false
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
    
    func animateClock() {
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveLinear, animations: {
            self.counterLabel.text = "\(self.counterClock)" + NSLocalizedString(" seconds", comment: " seconds")
        }) { (_) in
            if self.counterClock < 60 {
                self.counterClock+=1
                
                self.animateClock()
                
            }
            
        }
    }
}

extension TutorialARViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(floor(scrollView.contentOffset.x / self.view.frame.width))
        
        self.pageControl.currentPage = page
        
        //Move the hand to click on the fire
        if page == 2 {
            if shouldAnimateTap {
                self.animateTap()
            }
            
        }
        
        if page == 3 {
            self.animateClock()
        }
        
        
        if page > 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.backButton.alpha = 1
                
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.backButton.alpha = 0
                
            })
        }
        
        if page == pageControl.numberOfPages - 1 {
            // esconde botao de pular
            UIView.animate(withDuration: 0.5, animations: {
                //self.nextButton.isHidden = true
                self.nextButton.alpha = 0
                self.playButton.alpha = 1
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.nextButton.alpha = 1
                self.playButton.alpha = 0
                
            })
        }
        
    }
}
