//
//  ReadingViewController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/18/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class ReadingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var versesTableView: UITableView!
    @IBOutlet weak var chapterReferenceLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var currentBook = 0
    var currentChapter = 0
    var currentNoteText = ""
    var cellLocationInScriptures = [0, 0, 0, 0] {
        didSet {
            print(self.cellLocationInScriptures)
        }
    }
    // TODO: Remove line from bottom of Nav Controller
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScriptures()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: animated)
    }
    
    // MARK: - TableView Protocol Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch ScriptureController.shared.selectedTestament {
        case TestamentKeys.DaC:
            return ScriptureController.shared.decodedDoctrine?.sections[currentChapter].verses.count ?? 0
        default:
            return ScriptureController.shared.decodedTestament?.books[currentBook].chapters[currentChapter].verses.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "verseCell", for: indexPath) as? VerseCell else { return UITableViewCell() }
        
        switch ScriptureController.shared.selectedTestament {
        case TestamentKeys.DaC:
            if let verseText = ScriptureController.shared.decodedDoctrine?.sections[currentChapter].verses[indexPath.row].text,
                let verseNumber = ScriptureController.shared.decodedDoctrine?.sections[currentChapter].verses[indexPath.row].verse {
                cell.verseTextLabel?.text = "\(verseNumber))  " + verseText
            }
            
        default:
            if let verseText = ScriptureController.shared.decodedTestament?.books[currentBook].chapters[currentChapter].verses[indexPath.row].text,
                let verseNumber = ScriptureController.shared.decodedTestament?.books[currentBook].chapters[currentChapter].verses[indexPath.row].verse {
                cell.verseTextLabel?.text = "\(verseNumber))  " + verseText
                
            }
        }
        
        setupCellAtLocation(indexPathRow: indexPath.row, cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "verseCell", for: indexPath) as? VerseCell else { return }
        
        setupCellAtLocation(indexPathRow: indexPath.row, cell: cell)
    }
    
    // MARK: - Actions
    @IBAction func navigationButtonTapped(_ sender: UIButton) {
        
        switch sender.tag {
            
        case 0:
            currentChapter -= 1
            rightButton.isHidden = false
            if currentChapter == 0 {
                leftButton.isHidden = true
            }
            
        default:
            currentChapter += 1
            leftButton.isHidden = false
            if currentChapter == (ScriptureController.shared.decodedTestament?.books[currentBook].chapters.count ?? 1) - 1 {
                rightButton.isHidden = true
            }
            
        }
        
        self.versesTableView.reloadData()
        if let chapterNumber = ScriptureController.shared.decodedTestament?.books[currentBook].chapters[currentChapter].chapter {
            chapterReferenceLabel.text = "Chapter " + "\(chapterNumber)"
        }
    }
    
    @IBAction func noteButtonTapped(_ sender: Any) {
        
        let noteView = Bundle.main.loadNibNamed("NoteView", owner: nil, options: nil)?.first! as! NoteView
        //lazy load
    }
    
    // MARK: - Setup View Methods
    func setupTableView() {
        
        versesTableView.delegate = self
        versesTableView.dataSource = self
        versesTableView.separatorStyle = .none
    }
    
    func setupScriptures() {
        
        ScriptureController.shared.decode(book: currentBook, inTestament: ScriptureController.shared.selectedTestament ?? TestamentKeys.BoM)
        
        switch ScriptureController.shared.selectedTestament {
            
        case TestamentKeys.DaC:
            title = "Doctrine and Covenants"
            if let sectionNumber = ScriptureController.shared.decodedDoctrine?.sections[currentChapter].section {
                chapterReferenceLabel.text = "Section " + "\(sectionNumber)"
            }
        default:
            title = ScriptureController.shared.decodedTestament?.books[currentBook].book
            if let chapterNumber = ScriptureController.shared.decodedTestament?.books[currentBook].chapters[currentChapter].chapter {
                chapterReferenceLabel.text = "Chapter " + "\(chapterNumber)"
            }
        }
        if currentChapter == 0 {
            leftButton.isHidden = true
        } else if currentChapter == (ScriptureController.shared.decodedTestament?.books[currentBook].chapters.count ?? 1) - 1 {
            rightButton.isHidden = true
        }
    }
    
    func setupNavBar() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func setupCellAtLocation(indexPathRow: Int, cell: VerseCell) {
        
        var cellLocation = [0, 0, 0, 0]
        cellLocation[0] = TestamentKeys.reverseSelectedTestament[ScriptureController.shared.selectedTestament ?? TestamentKeys.BoM] ?? 0
        cellLocation[1] = currentBook
        cellLocation[2] = currentChapter
        cellLocation[3] = indexPathRow
        self.cellLocationInScriptures = cellLocation
        
        var hasNote = false
        for verse in VerseDetailsController.shared.allVerseDetails {
            if verse.isHighlighted == true {
                cell.backgroundColor = UIColor.yellow
            }
            if verse.verseNote?.noteLocation == cellLocationInScriptures {
                hasNote = true
                guard let verseNoteText = verse.verseNote?.noteText else { return }
                cell.verseTextLabel.text = verseNoteText
            }
        }
        cell.noteButton.isHidden = !hasNote
    }
}

// TODO: Tap a verse to open a menu -
// Highlight Verse
// Write Impression
// Add to Favorites
// Save for Memorization
// Copy
// Share
