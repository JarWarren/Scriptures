//
//  MemorizeView.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/7/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class MemorizeView: UIView {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var memorizeButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    var delegate: MemorizeViewDelegate?
    var isDoctrine = false
    var chapter: ChapterCD?
    var section: SectionCD?
    var allVerses = [VerseCD]()
    var minIndex = 0
    var maxIndex = 0
    var currentIndex = 0
    var verse: VerseCD? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: Actions
    @IBAction func closeButtonTapped(_ sender: Any) {
        delegate?.hideSubviews()
    }
    
    @IBAction func memorizeButtonTapped(_ sender: Any) {
        let indexSet = IndexSet(integersIn: minIndex...currentIndex)
        if let versesToBeMemorized = chapter?.verses?.objects(at: indexSet) as? [VerseCD] {
            VerseController.shared.memorize(verses: versesToBeMemorized)
        }
        delegate?.hideSubviews()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        rightButton.isHidden = false
        addButton.isHidden = true
        endLabel.isHidden = false
        
        guard let index = verse?.verse else { return }
        currentIndex = Int(index - 1)
        minIndex = Int(index - 1)
        
        switch isDoctrine {
        case true:
            let indexSet = IndexSet(integersIn: currentIndex...(section?.verses?.count)! - 1)
            guard let verses = section?.verses?.objects(at: indexSet) as? [VerseCD] else { return }
            printVerses(verses: verses)
            allVerses = verses
            maxIndex = verses.count - 1
            currentIndex += 1
            endLabel.text = verses[currentIndex].reference
        case false:
            let indexSet = IndexSet(integersIn: currentIndex...(chapter?.verses?.count)! - 1)
            guard let verses = chapter?.verses?.objects(at: indexSet) as? [VerseCD] else { return }
            printVerses(verses: verses)
            allVerses = verses
            currentIndex += 1
            maxIndex = verses.count - 1
            endLabel.text = verses[currentIndex].reference
        }
    }
    
    @IBAction func navigationButtonTapped(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            currentIndex -= 1
            rightButton.isHidden = false
            if currentIndex == minIndex {
                leftButton.isHidden = true
                rightButton.isHidden = true
                addButton.isHidden = false
                endLabel.isHidden = true
            }
        case 1:
            currentIndex += 1
            leftButton.isHidden = false
            if currentIndex == maxIndex {
                rightButton.isHidden = true
            }
        default: return
        }
        endLabel.text = allVerses[currentIndex].reference
    }
    
    // MARK: Setup
    func setupView() {
        
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        closeButton.layer.borderColor = UIColor.lightGray.cgColor
        closeButton.layer.borderWidth = 1
        
        memorizeButton.layer.cornerRadius = memorizeButton.frame.height / 2
        memorizeButton.layer.borderColor = UIColor.lightGray.cgColor
        memorizeButton.layer.borderWidth = 1
        
        addButton.layer.cornerRadius = addButton.frame.height / 2
        addButton.layer.borderColor = UIColor.lightGray.cgColor
        addButton.layer.borderWidth = 1
        
        endLabel.isHidden = true
        leftButton.isHidden = true
        rightButton.isHidden = true
    }
    
    func updateView() {
        startLabel.text = verse?.reference
        if let chapter = verse?.chapter {
            self.chapter = chapter
            if chapter.verses?.count == 1 {
                addButton.isHidden = true
            }
        } else {
            self.section = verse?.section
            if chapter?.verses?.count == 1 {
                addButton.isHidden = true
            }
            isDoctrine = true
        }
    }
    
    func printVerses(verses: [VerseCD]) {
        for verse in verses {
            print(verse.verse)
        }
    }
}

// MARK: Protocol
protocol MemorizeViewDelegate: class {
    
    func hideSubviews()
}