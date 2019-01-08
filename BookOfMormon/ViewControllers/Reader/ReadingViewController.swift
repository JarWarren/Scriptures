//
//  ReadingViewController.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/18/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class ReadingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VerseCellDelegate, NoteViewDelegate, ColorViewDelegate, MemorizeViewDelegate {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var versesTableView: UITableView!
    @IBOutlet weak var chapterReferenceLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet var highlighterButtonView: UIView!
    @IBOutlet weak var highlighterButtonViewButton: UIButton!
    @IBOutlet weak var darkView: UIView!
    var subviews = [UIView]() {
        didSet {
            print("\(subviews.count) subviews.")
        }
    }
    var currentBook = 0
    var currentChapter = 0
    var selectedVerse: VerseCD?
    var selectedIndexPath: IndexPath?
    var bookmarkLocation = [0, 0, 0]
    var highlightColorButton: UIBarButtonItem?
    var colorViewIsVisible = false
    var noteViewIsVisible = false {
        didSet {
            switch noteViewIsVisible {
            case true: return
            case false: versesTableView.reloadData()
            }
        }
    }
    // TODO: Remove line from bottom of Nav Controller
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScriptures()
        setupTableView()
        setupBookmarkButton()
        setupHighlighterButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: animated)
    }
    
    // MARK: - TableView Methods
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
        
        cell.delegate = self
        switch ScriptureController.shared.selectedTestament {
        case TestamentKeys.DaC:
            let sections = ScriptureController.shared.fetchedDoctrine?.sections?.array as? [SectionCD]
            let verses = sections?[currentChapter].verses?.array as? [VerseCD]
            cell.verseCoreData = verses?[indexPath.row]
            
        default:
            let books = ScriptureController.shared.fetchedTestament?.books?.array as? [BooksCD]
            let chapters = books?[currentBook].chapters?.allObjects as? [ChapterCD]
            let verses = chapters?[currentChapter].verses?.array as? [VerseCD]
            cell.verseCoreData = verses?[indexPath.row]
        }
        if cell.verseCoreData?.isHighlighted == true {
            if let color = cell.verseCoreData?.color {
                cell.backgroundColor = HighlighterColorKey.colorDictionary[color]
            }
        } else {
            cell.backgroundColor = UIColor.white
        }
        if cell.verseCoreData?.noteTitle == nil {
            cell.noteButton.isHidden = true
        } else {
            cell.noteButton.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? VerseCell else { return }
        
        self.selectedVerse = cell.verseCoreData
        self.selectedIndexPath = indexPath
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideSubviews()
    }
    
    // MARK: - Actions
    @IBAction func navigationButtonTapped(_ sender: UIButton) {
        
        hideSubviews()
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
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        
        hideSubviews()
        if selectedVerse == nil && sender.tag != 4 && sender.tag != 1 {
            
            tapAVerseAlert()
        } else {
            
            switch sender.tag {
                
            case 0: // Highlight
                if selectedVerse?.isHighlighted == nil || selectedVerse?.isHighlighted == false {
                    selectedVerse?.isHighlighted = true
                    selectedVerse?.color = Int64(HighlighterColorController.shared.currentColorAsInt)
                } else {
                    selectedVerse?.isHighlighted = false
                }
                
            case 1: // Note
                switch selectedVerse == nil {
                    
                case true:
                    tapAVerseAlert()
                    
                case false:
                    guard let noteView = Bundle.main.loadNibNamed("Note", owner: nil, options: nil)![0] as? NoteView else { return }
                    noteView.translatesAutoresizingMaskIntoConstraints = false
                    darkenBackground()
                    self.view.addSubview(noteView)
                    noteView.delegate = self
                    self.subviews.append(noteView)
                    self.noteViewIsVisible = true
                    noteView.layer.cornerRadius = 15
                    noteView.layer.borderColor = UIColor.lightGray.cgColor
                    noteView.layer.borderWidth = 1
                    NSLayoutConstraint.activate([
                        noteView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                        noteView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                        noteView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),
                        noteView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9)])
                    noteView.verse = selectedVerse
                    if selectedVerse?.noteText == nil {
                        noteView.isEditing = true
                    } else {
                        noteView.isEditing = false
                    }
                }
                
            case 2: // Memorize
                guard let memorizeView = Bundle.main.loadNibNamed("Memorize", owner: nil, options: nil)![0] as? MemorizeView else { return }
                memorizeView.translatesAutoresizingMaskIntoConstraints = false
                darkenBackground()
                self.view.addSubview(memorizeView)
                memorizeView.delegate = self
                self.subviews.append(memorizeView)
                //memorize view delegate self?
                memorizeView.layer.cornerRadius = 15
                memorizeView.layer.borderWidth = 1
                memorizeView.layer.borderColor = UIColor.lightGray.cgColor
                NSLayoutConstraint.activate([
                    memorizeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    memorizeView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                    memorizeView.heightAnchor.constraint(equalToConstant: 150),
                    memorizeView.widthAnchor.constraint(equalToConstant: 200)])
                memorizeView.verse = selectedVerse
                
                guard let verseInt = selectedVerse?.verse else { return }
                if Int(verseInt) == selectedVerse?.chapter?.verses?.count || Int(verseInt) == selectedVerse?.section?.verses?.count {
                    memorizeView.isFinalVerse = true
                }
                
            case 3: // Copy
                UIPasteboard.general.string = selectedVerse?.text
                
            case 4: // Bookmark
                findBookmarkLocation()
                BookmarkController.shared.bookmarkAt(location: bookmarkLocation)
                setupBookmarkButton()
                
            default: return
            }
            try? CoreDataStack.managedObjectContext.save()
            
            if let indexPath = selectedIndexPath {
                versesTableView.deselectRow(at: indexPath, animated: true)
                versesTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    @objc @IBAction func highlighterButtonTapped(_ sender: Any) {
        
        hideSubviews()
        switch colorViewIsVisible {
        case false :
            guard let colorView = Bundle.main.loadNibNamed("HighlighterColors", owner: nil, options: nil)![0] as? HighlighterColorsView else { return }
            colorView.translatesAutoresizingMaskIntoConstraints = false
            darkenBackground()
            self.view.addSubview(colorView)
            colorView.delegate = self
            self.subviews.append(colorView)
            colorView.layer.cornerRadius = 15
            colorView.layer.borderColor = UIColor.lightGray.cgColor
            colorView.layer.borderWidth = 1
            NSLayoutConstraint.activate([
                colorView.widthAnchor.constraint(equalToConstant: 200),
                colorView.heightAnchor.constraint(equalToConstant: 200),
                colorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                colorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
            colorViewIsVisible = true
        case true :
            colorViewIsVisible = false
        }
    }
    
    // MARK: - Setup View Methods
    func setupTableView() {
        
        versesTableView.delegate = self
        versesTableView.dataSource = self
        versesTableView.separatorStyle = .none
    }
    
    func setupHighlighterButton() {
        
        self.highlightColorButton = UIBarButtonItem(customView: highlighterButtonView)
        self.highlighterButtonViewButton.backgroundColor = HighlighterColorController.shared.currentColor
        self.highlighterButtonViewButton.layer.cornerRadius = 5
        highlighterButtonView.layer.cornerRadius = 5
        highlighterButtonView.layer.borderColor = UIColor.lightGray.cgColor
        highlighterButtonView.layer.borderWidth = 1
        highlightColorButton?.target = self
        highlightColorButton?.action = #selector(highlighterButtonTapped)
        self.navigationItem.rightBarButtonItem = self.highlightColorButton
    }
    
    func setupScriptures() {
        
        self.view.addSubview(darkView)
        darkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            darkView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            darkView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            darkView.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor)
            ])
        darkView.isHidden = true
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
    
    
    func hideSubviews() {
        darkView.isHidden = true
        for view in subviews {
            view.isHidden = true
        }
        subviews.removeAll()
    }
    
    func tapAVerseAlert() {
        
        let alertController = UIAlertController(title: "Tap a verse in order to use this option", message: nil, preferredStyle: .actionSheet)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
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
    
    func darkenBackground() {
        darkView.isHidden = false
    }
    
    func updateColorButton () {
        
        self.highlighterButtonViewButton.backgroundColor = HighlighterColorController.shared.currentColor
    }
    
    func findBookmarkLocation() {
        
        var currentLocation = [0, 0, 0]
        currentLocation[0] = TestamentKeys.reverseSelectedTestament[ScriptureController.shared.selectedTestament ?? TestamentKeys.BoM] ?? 0
        currentLocation[1] = currentBook
        currentLocation[2] = currentChapter
        self.bookmarkLocation = currentLocation
    }
}
// TODO:
// Highlight Verse (different colors)
// Write Impression
// Add to Favorites
// Save for Memorization
// Copy
// Share

//TODO: Add a memorize view that lets me add a start verse and end verse and save all of them together as a single memorize unit.
