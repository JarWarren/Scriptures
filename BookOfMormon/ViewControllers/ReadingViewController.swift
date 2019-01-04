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
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var currentBook = 0
    var currentChapter = 0
    var selectedVerse: VerseCD?
    var selectedIndexPath: IndexPath?
    var bookmarkLocation = [0, 0, 0]
    // TODO: Remove line from bottom of Nav Controller
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScriptures()
        setupTableView()
        setupBookmarkButton()
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
            let sections = ScriptureController.shared.fetchedDoctrine?.sections?.array as? [SectionCD]
            return sections?[currentChapter].verses?.count ?? 0
        default:
            let books = ScriptureController.shared.fetchedTestament?.books?.array as? [BooksCD]
            let chapters = books?[currentBook].chapters?.allObjects as? [ChapterCD]
            return chapters?[currentChapter].verses?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "verseCell", for: indexPath) as? VerseCell else { return UITableViewCell() }
        
        switch ScriptureController.shared.selectedTestament {
        case TestamentKeys.DaC:
            let sections = ScriptureController.shared.fetchedDoctrine?.sections?.array as? [SectionCD]
            let verses = sections?[currentChapter].verses?.array as? [VerseCD]
            cell.verseCoreData = verses?[indexPath.row]
            
        default:
            let books = ScriptureController.shared.fetchedTestament?.books?.array as? [BooksCD]
            let chapters = books?[currentBook].chapters?.allObjects as? [ChapterCD]
            let verses = chapters?[currentChapter].verses?.allObjects as? [VerseCD]
            cell.verseCoreData = verses?[indexPath.row]
        }
        if cell.verseCoreData?.isHighlighted == true {
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.8192489743, blue: 0.8509001136, alpha: 1)
        } else {
            cell.backgroundColor = UIColor.white
        }
        if cell.verseCoreData?.note == nil {
            cell.noteButton.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? VerseCell else { return }
        
        self.selectedVerse = cell.verseCoreData
        self.selectedIndexPath = indexPath
    }
    
    // MARK: - Actions
    @IBAction func navigationButtonTapped(_ sender: UIButton) {
        
        self.selectedVerse = nil
        let books = ScriptureController.shared.fetchedTestament?.books?.array as? [BooksCD]
        let chapters = books?[currentBook].chapters?.allObjects as? [ChapterCD]
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
            if currentChapter == (books?[currentBook].chapters?.count ?? 1) - 1 {
                rightButton.isHidden = true
            }
            
        }
        
        self.versesTableView.reloadData()
        setupBookmarkButton()
        if let chapterNumber = chapters?[currentChapter].chapter {
            chapterReferenceLabel.text = "Chapter " + "\(chapterNumber)"
        }
    }
    
    @IBAction func cellMenuButtonTapped(_ sender: UIButton) {
        
        if selectedVerse == nil && sender.tag != 2 {
            
            let alertController = UIAlertController(title: "Tap a verse in order to use this option", message: nil, preferredStyle: .actionSheet)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            switch sender.tag {
            case 0:
                if selectedVerse?.isHighlighted == nil || selectedVerse?.isHighlighted == false {
                    selectedVerse?.isHighlighted = true
                } else {
                    selectedVerse?.isHighlighted = false
                }
            case 1:
                print("let them write a note")
            case 2:
                findBookmarkLocation()
                BookmarkController.shared.bookmarkAt(location: bookmarkLocation)
                setupBookmarkButton()
            case 3:
                UIPasteboard.general.string = selectedVerse?.text
            default: return
            }
            try? CoreDataStack.managedObjectContext.save()
            
            if let indexPath = selectedIndexPath {
                versesTableView.deselectRow(at: indexPath, animated: true)
                versesTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    // MARK: - Setup View Methods
    func setupTableView() {
        
        versesTableView.delegate = self
        versesTableView.dataSource = self
        versesTableView.separatorStyle = .none
    }
    
    func setupScriptures() {
        
        let books = ScriptureController.shared.fetchedTestament?.books?.array as! [BooksCD]
        
        switch ScriptureController.shared.selectedTestament {
            
        case TestamentKeys.DaC:
            title = "Doctrine and Covenants"
            let sections = ScriptureController.shared.fetchedDoctrine?.sections?.array as? [SectionCD]
            if let sectionNumber = sections?[currentChapter].section {
                chapterReferenceLabel.text = "Section " + "\(sectionNumber)"
            }
            
        default:
            let chapters = books[currentBook].chapters?.allObjects as? [ChapterCD]
            title = books[currentBook].book
            if let chapterNumber = chapters?[currentChapter].chapter {
                chapterReferenceLabel.text = "Chapter " + "\(chapterNumber)"
            }
        }
        if currentChapter == 0 {
            leftButton.isHidden = true
        }
        if currentChapter == (books[currentBook].chapters?.count ?? 1) - 1 {
            rightButton.isHidden = true
        }
        if leftButton.isHidden == true && rightButton.isHidden == true {
            chapterReferenceLabel.isHidden = true
        }
    }
    
    func setupNavBar() {
        
        // Remove shadow from Navigation Bar.
    }
    
    func setupBookmarkButton() {
        guard let currentTestament = ScriptureController.shared.selectedTestament,
            let bookmark = BookmarkController.shared.bookmark else {
                bookmarkButton.setTitle("Bookmark", for: .normal)
                bookmarkButton.setTitleColor(#colorLiteral(red: 0.006345573347, green: 0.478813827, blue: 0.9984634519, alpha: 1), for: .normal)
                return
        }
        if TestamentKeys.reverseSelectedTestament[currentTestament] == Int(bookmark.testament) &&
            self.currentBook == Int(bookmark.book) &&
            self.currentChapter == Int(bookmark.chapter) {
            bookmarkButton.setTitle("Bookmarked", for: .normal)
            bookmarkButton.setTitleColor(#colorLiteral(red: 0.7324364781, green: 0.111247398, blue: 0.3787733316, alpha: 1), for: .normal)
        } else {
            bookmarkButton.setTitle("Bookmark", for: .normal)
            bookmarkButton.setTitleColor(#colorLiteral(red: 0.006345573347, green: 0.478813827, blue: 0.9984634519, alpha: 1), for: .normal)
        }
    }
    
    func findBookmarkLocation() {
        
        var currentLocation = [0, 0, 0]
        currentLocation[0] = TestamentKeys.reverseSelectedTestament[ScriptureController.shared.selectedTestament ?? TestamentKeys.BoM] ?? 0
        currentLocation[1] = currentBook
        currentLocation[2] = currentChapter
        self.bookmarkLocation = currentLocation
    }
}

// TODO: Tap a verse to open a menu -
// Highlight Verse (different colors)
// Write Impression
// Add to Favorites
// Save for Memorization
// Copy
// Share
