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
    var currentBook = 0
    var currentChapter = 0

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScriptures()
        versesTableView.delegate = self
        versesTableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popToRootViewController(animated: animated)
    }
    
    // MARK: - TableView Protocol Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ScriptureController.shared.decodedTestament?.books[currentBook].chapters[currentChapter].verses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "verseCell", for: indexPath)
        
        if let verseText = ScriptureController.shared.decodedTestament?.books[currentBook].chapters[currentChapter].verses[indexPath.row].text,
            let verseNumber = ScriptureController.shared.decodedTestament?.books[currentBook].chapters[currentChapter].verses[indexPath.row].verse {
            cell.textLabel?.text = "\(verseNumber))  " + verseText
        }
        return cell
    }
    
    // MARK: - Setup View Methods
    func setupScriptures() {
        ScriptureController.shared.decode(book: currentBook, inTestament: ScriptureController.shared.selectedTestament ?? TestamentKeys.BoM)
        title = ScriptureController.shared.decodedTestament?.books[currentBook].book
        if let chapterNumber = ScriptureController.shared.decodedTestament?.books[currentBook].chapters[currentChapter].chapter {
            chapterReferenceLabel.text = "Chapter " + "\(chapterNumber)"
        }
    }
}

// TODO: Tap a verse to open a menu -
// Highlight Verse
// Write Impression
// Add to Favorites
// Save for Memorization
