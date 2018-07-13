//
//  FinalizationViewcontroller.swift
//  Save the Trees!
//
//  Created by Leonardo Alves de Melo on 15/03/18.
//  Copyright © 2018 Leonardo Alves de Melo. All rights reserved.
//

import UIKit

class FinalizationViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var replayLabel: UILabel!
    
    var savedTreesPercentage: Int? = nil
    
    var counterLabel:UILabel!
    
    var tutorialText: [NSMutableAttributedString] = []
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let message1 = lightAttributedString(text: "")
        
        // Primeira mensagem
        if self.savedTreesPercentage! == 0 {
            message1.append(lightAttributedString(text: NSLocalizedString("Even with your magical power, you let ", comment: "Even with your magical power, you let ")))
            message1.append(boldAttributedString(text: NSLocalizedString("all the trees die!", comment: "all the trees die!")))
        }
        else if self.savedTreesPercentage! < 85 {
            message1.append(lightAttributedString(text: NSLocalizedString("Even with your magical power, you saved ", comment: "Even with your magical power, you saved ")))
            message1.append(boldAttributedString(text: NSLocalizedString("only ", comment: "only ")))
            message1.append(boldAttributedString(text: "\(self.savedTreesPercentage!)% "))
            message1.append(lightAttributedString(text: NSLocalizedString("of the forest", comment: "of the forest")))
        }
        else {
            message1.append(lightAttributedString(text: NSLocalizedString("Congratulations! You saved ", comment: "Congratulations! You saved ")))
            message1.append(boldAttributedString(text: "\(self.savedTreesPercentage!)% "))
            message1.append(lightAttributedString(text: NSLocalizedString("of the forest!", comment: "of the forest!")))
        }

        
        
        // Segunda mensagem
        let message2 = lightAttributedString(text: NSLocalizedString("Sadly, in real world ", comment: "Sadly, in real world "))
        message2.append(boldAttributedString(text: NSLocalizedString("nobody ", comment: "nobody ")))
        message2.append(lightAttributedString(text: NSLocalizedString("has this kind of power", comment: "has this kind of power")))
        
        // Terceira mensagem
        let message3 = lightAttributedString(text: NSLocalizedString("Perhaps, there are some actions ", comment: "Perhaps, there are some actions "))
        message3.append(boldAttributedString(text: NSLocalizedString("you could do ", comment: "you could do ")))
        message3.append(lightAttributedString(text: NSLocalizedString("in the real world to save ", comment: "in the real world to save ")))
        message3.append(boldAttributedString(text: NSLocalizedString("even more trees", comment: "even more trees")))
        
        let message4 = boldAttributedString(text: NSLocalizedString("Support these NGOs:\n\n", comment: "Support these NGOs:\n\n"))
        
        message4.append(boldAttributedString(text: "- WWF Brasil: "))
        message4.append(lightAttributedString(text:  NSLocalizedString("WWF ensures the delivery of innovative solutions that meet the needs of both people and nature.\n", comment: "WWF ensures the delivery of innovative solutions that meet the needs of both people and nature.\n")))
        message4.append(boldAttributedString(text: "www.wwf.org.br/\n\n"))
        
        message4.append(boldAttributedString(text: "- SOS Amazônia: "))
        message4.append(lightAttributedString(text: NSLocalizedString("SOS Amazônia helps to create public policies for environmental protection and awareness in Amazon rainforest.\n", comment: "SOS Amazônia helps to create public policies for environmental protection and awareness in Amazon rainforest.\n")))
        message4.append(boldAttributedString(text: "www.sosamazonia.org.br/\n\n"))
        
        message4.append(boldAttributedString(text: "- Imazon: "))
        message4.append(lightAttributedString(text: NSLocalizedString("Imazon mission's is to promote sustainable development in the Amazon through studies, support for public policy formulation, broad dissemination of information and capacity building.\n", comment: "Imazon mission's is to promote sustainable development in the Amazon through studies, support for public policy formulation, broad dissemination of information and capacity building.\n")))
        message4.append(boldAttributedString(text: "www.imazon.org.br/"))
        
        self.tutorialText.append(message1)
        self.tutorialText.append(message2)
        self.tutorialText.append(message3)
        self.tutorialText.append(message4)
        
        self.pageControl.numberOfPages = tutorialText.count
        self.replayButton.alpha = 0
        self.replayLabel.alpha = 0
        self.backButton.alpha = 0
        
        self.setupScrollView()
        self.setupCounterLabel()
        self.setupSadFace()
        self.setupIdea()
        
        self.animateCounterLabel()
        
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x + self.scrollView.frame.width, y: self.scrollView.contentOffset.y), animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x - self.scrollView.frame.width, y: self.scrollView.contentOffset.y), animated: true)
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
    
    func setupScrollView() {
        var index = 0
        //Add all pages in scrollView
        for text in tutorialText {
            let label = UILabel(frame: CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: self.view.frame.width*0.8, height: self.view.frame.height))
            
            label.center = CGPoint(x: view.center.x, y:view.frame.height * CGFloat(3)/CGFloat(4))
            label.textAlignment = .center
            label.attributedText = text
            label.numberOfLines = 0
            label.textColor = UIColor.white
            label.frame = (label.frame.offsetBy(dx: scrollView.contentSize.width, dy: 0))
            
            if index == tutorialText.count - 1 {
                label.center = CGPoint(x: label.center.x, y: CGFloat(view.frame.height/2 - 50))
                label.textAlignment = .left
            }
            
            scrollView.addSubview(label)
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width + self.view.frame.width, height: label.frame.height)
            
            index += 1
        }
    }
    
    func setupSadFace() {
        let label = UILabel(frame: CGRect(x: self.view.frame.width*2/2, y: self.view.frame.height/2, width: self.view.frame.width*0.8, height: self.view.frame.height))
        label.center = CGPoint(x: self.view.center.x + self.view.frame.width, y: self.view.center.y)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = ":'("
        label.numberOfLines = 1
        label.font = label.font.withSize(50)
        self.scrollView.addSubview(label)
    }
    
    func setupIdea() {
        let label = UILabel(frame: CGRect(x: self.view.frame.width*3/2, y: self.view.frame.height/2, width: self.view.frame.width*0.8, height: self.view.frame.height))
        label.center = CGPoint(x: self.view.center.x + self.view.frame.width*2, y: self.view.center.y)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "!"
        label.numberOfLines = 1
        label.font = label.font.withSize(50)
        self.scrollView.addSubview(label)
    }
    
    func setupCounterLabel() {
        self.counterLabel = UILabel(frame: CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: self.view.frame.width*0.8, height: self.view.frame.height))
        self.counterLabel.center = self.view.center
        self.counterLabel.textAlignment = .center
        self.counterLabel.textColor = UIColor.white
        self.counterLabel.text = "0%"
        self.counterLabel.numberOfLines = 1
        self.counterLabel.font = self.counterLabel.font.withSize(50)
        self.scrollView.addSubview(self.counterLabel)
    }
    
    func animateCounterLabel() {
        
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveLinear, animations: {
            self.counterLabel.text = "\(self.counter)%"
            
        }) { (_) in
            if self.counter < self.savedTreesPercentage! {
                self.counter+=1
                self.animateCounterLabel()
            }
        }
        
    }
}


extension FinalizationViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(floor(scrollView.contentOffset.x / self.view.frame.width))
        
        self.pageControl.currentPage = page
        
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
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.nextButton.alpha = 0
                self.replayButton.alpha = 1
                self.replayLabel.alpha = 1
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.nextButton.alpha = 1
                self.replayLabel.alpha = 0
                self.replayButton.alpha = 0
                
            })
        }
        
    }
}
