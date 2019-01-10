//
//  VerseCell.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/31/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class VerseCell: UITableViewCell {
    
    //MARK: Outlets
    weak var delegate: VerseCellDelegate?
    @IBOutlet weak var verseTextLabel: UILabel!
    @IBOutlet weak var noteButton: UIButton!
    var verseCoreData: VerseCD? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        if let verseText = self.verseCoreData?.text,
            let verseNumber = self.verseCoreData?.verse {
     self.verseTextLabel.text = "\(verseNumber))  " + verseText
        }
    }
    
    @IBAction func noteButtonTapped(_ sender: UIButton) {
        delegate?.selectedVerse = verseCoreData
        delegate?.menuButtonTapped(sender)
    }
}

protocol VerseCellDelegate: class {
    
    func menuButtonTapped(_ sender: UIButton)
    var selectedVerse: VerseCD? { get set }
}
