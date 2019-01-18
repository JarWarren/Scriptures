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
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var highlighterMenuButton: UIButton!
    @IBOutlet weak var menuStackView: UIStackView!
    var subviews = [UIView]() {
        didSet {
            print("\(subviews.count) subviews.")
        }
    }
    var currentBook = 0
    var currentChapter = 0
    var selectedVerse: VerseCD?
    var selectedIndexPath: IndexPath?
    var bookmarkOrGoalLocation = [0, 0, 0]
    var highlightColorButton: UIBarButtonItem?
    var colorViewIsVisible = false
    var bookmarkShouldEditGoal = false
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
        setupViewAndScriptures()
        
        setupTableView()
        setupBookmarkButton()
        setupHighlighterButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCustomNavBar()
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
            let chapters = books?[currentBook].chapters?.array as? [ChapterCD]
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
            let chapters = books?[currentBook].chapters?.array as? [ChapterCD]
            let verses = chapters?[currentChapter].verses?.array as? [VerseCD]
            cell.verseCoreData = verses?[indexPath.row]
        }
        if cell.verseCoreData?.isHighlighted == true {
            if let color = cell.verseCoreData?.color {
                cell.backgroundColor = ColorKey.colorDictionary[color]
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
        
        switch ScriptureController.shared.selectedTestament == TestamentKeys.DaC {
        case true:
            let sections = ScriptureController.shared.fetchedDoctrine?.sections?.array as? [SectionCD]
            switch sender.tag {
            case 0:
                currentChapter -= 1
                rightButton.isHidden = false
                if currentChapter == 0 {
                    self.leftButton.isHidden = true
                }
            default:
                currentChapter += 1
                leftButton.isHidden = false
                if currentChapter == 137 {
                    self.rightButton.isHidden = true
                }
            }
            if let sectionNumber = sections?[currentChapter].section {
                chapterReferenceLabel.text = "Section " + "\(sectionNumber)"
            }
        default:
            let books = ScriptureController.shared.fetchedTestament?.books?.array as? [BooksCD]
            switch sender.tag {
                
            case 0:
                currentChapter -= 1
                rightButton.isHidden = false
                if currentChapter == -1 {
                    
                    self.title = books?[currentBook - 1].book
                    currentChapter = (books?[currentBook - 1].chapters?.count ?? 1) - 1
                    currentBook -= 1
                }
                
            default:
                leftButton.isHidden = false
                
                currentChapter += 1
                if currentChapter == (books?[currentBook].chapters?.count ?? 1) {
                    
                    self.title = books?[currentBook + 1].book
                    currentBook += 1
                    currentChapter = 0
                }
            }
            let chapters = books?[currentBook].chapters?.array as? [ChapterCD]
            if let chapterNumber = chapters?[currentChapter].chapter {
                chapterReferenceLabel.text = "Chapter " + "\(chapterNumber)"
            }
            if (currentBook + 1) == ScriptureController.shared.fetchedTestament?.books?.count && (currentChapter + 1) == books?[currentBook].chapters?.count {
                self.rightButton.isHidden = true
            }
            if currentBook == 0 && currentChapter == 0 {
                self.leftButton.isHidden = true
            }
        }
        self.versesTableView.reloadData()
        setupBookmarkButton()
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
                if bookmarkShouldEditGoal == false {
                    BookmarkController.shared.bookmarkAt(location: bookmarkOrGoalLocation)
                } else {
                    GoalController.shared.updatePrimaryGoalLocation(location: bookmarkOrGoalLocation)
                }
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
            guard let colorView = Bundle.main.loadNibNamed("ColorView", owner: nil, options: nil)![0] as? ColorView else { return }
            colorView.translatesAutoresizingMaskIntoConstraints = false
            darkenBackground()
            self.view.addSubview(colorView)
            colorView.delegate = self
            self.subviews.append(colorView)
            colorView.layer.cornerRadius = 15
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
        
        let highlightColorButton = UIBarButtonItem(image: UIImage(named:"highlighterBarButton"), style: .plain, target: self, action: #selector(highlighterButtonTapped))
        highlightColorButton.tintColor = self.navigationController?.navigationBar.tintColor
        self.navigationItem.rightBarButtonItem = highlightColorButton
    }
    
    func setupViewAndScriptures() {
        
        self.view.addSubview(darkView)
        darkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            darkView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            darkView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            darkView.topAnchor.constraint(equalTo: versesTableView.topAnchor)
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
            let chapters = books[currentBook].chapters?.array as? [ChapterCD]
            title = books[currentBook].book
            if let chapterNumber = chapters?[currentChapter].chapter {
                chapterReferenceLabel.text = "Chapter " + "\(chapterNumber)"
            }
        }
        if currentBook == 0 && currentChapter == 0 {
            leftButton.isHidden = true
        }
        if (currentBook + 1) == books.count && (currentChapter + 1) == books[currentBook].chapters?.count {
            rightButton.isHidden = true
        }
        if ScriptureController.shared.selectedTestament == TestamentKeys.DaC && currentChapter == 137 {
            rightButton.isHidden = true
        }
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
        
        switch bookmarkShouldEditGoal {
        case false:
            guard let currentTestament = ScriptureController.shared.selectedTestament,
                let bookmark = BookmarkController.shared.bookmark else {
                    bookmarkButton.tintColor = UIColor.black
                    bookmarkButton.setImage(UIImage(named: "bookmark"), for: .normal)
                    return
            }
            if TestamentKeys.reverseSelectedTestament[currentTestament] == Int(bookmark.testament) &&
                self.currentBook == Int(bookmark.book) &&
                self.currentChapter == Int(bookmark.chapter) {
                bookmarkButton.tintColor = #colorLiteral(red: 0.7338222861, green: 0.1125283316, blue: 0.3782619834, alpha: 1)
                bookmarkButton.setImage(UIImage(named: "bookmarked"), for: .normal)
            } else {
                bookmarkButton.tintColor = UIColor.black
                bookmarkButton.setImage(UIImage(named: "bookmark"), for: .normal)
            }
        case true:
            if GoalController.shared.primary?.goal?.currentBook == Int64(currentBook) &&
                GoalController.shared.primary?.goal?.currentChapter == Int64(currentChapter) {
                
                bookmarkButton.setImage(UIImage(named: "goalBookmark"), for: .normal)
                bookmarkButton.tintColor = #colorLiteral(red: 0, green: 0.5016700625, blue: 0.005194439087, alpha: 1)
            } else {
                bookmarkButton.setImage(UIImage(named: "goalBookmark"), for: .normal)
                bookmarkButton.tintColor = #colorLiteral(red: 0.6313489079, green: 0.557828486, blue: 0.09932992607, alpha: 1)
            }
        }
    }
    
    func darkenBackground() {
        darkView.isHidden = false
    }
    
    func updateColor () {
        
        self.highlighterMenuButton.tintColor = HighlighterColorController.shared.currentColor
    }
    
    func findBookmarkLocation() {
        
        var currentLocation = [0, 0, 0]
        currentLocation[0] = TestamentKeys.reverseSelectedTestament[ScriptureController.shared.selectedTestament ?? TestamentKeys.BoM] ?? 0
        currentLocation[1] = currentBook
        currentLocation[2] = currentChapter
        self.bookmarkOrGoalLocation = currentLocation
    }
    
    func newMasteryBadge() {
        
        tabBarController?.viewControllers?[2].tabBarItem.badgeValue = "New"
    }
    
    func colorViewClosed() {
        self.colorViewIsVisible = false
    }
    
    func setupCustomNavBar() {
        
        self.navigationController?.navigationBar.shadowVisibile(false)
        let viewRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        let underlineView = UIView(frame: viewRect)
        underlineView.backgroundColor = #colorLiteral(red: 0.8901082873, green: 0.8902577162, blue: 0.8900884986, alpha: 1)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            underlineView.topAnchor.constraint(equalTo: versesTableView.topAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 1)])
    }
}
