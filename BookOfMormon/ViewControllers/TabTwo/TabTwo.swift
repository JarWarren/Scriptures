//
//  TabTwo.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/18/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class TabTwo: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var booksSegmentedControl: UISegmentedControl!
    var barButton: UIBarButtonItem?
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMainView()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTestament()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup View Methods
    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        ScriptureController.shared.change(testament: TestamentKeys.BoM) { (_) in
        }
    }
    
    // MARK: - CollectionView Data Source Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        switch ScriptureController.shared.selectedTestament {
        case TestamentKeys.DaC:
            return 1
        default:
            return ScriptureController.shared.fetchedTestament?.books?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch ScriptureController.shared.selectedTestament {
        case TestamentKeys.DaC:
            let sections = ScriptureController.shared.fetchedDoctrine?.sections?.array as? [SectionCD]
            return sections?.count ?? 0
        default:
            let books = ScriptureController.shared.fetchedTestament?.books?.array as? [BooksCD]
            return books?[section].chapters?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "chapterHeader", for: indexPath) as? ChapterHeader else { return UICollectionReusableView() }
        
        switch ScriptureController.shared.selectedTestament {
        case TestamentKeys.DaC:
            header.chapterHeaderLabel.text = "The Doctrine and Covenants"
        default:
            let books = ScriptureController.shared.fetchedTestament?.books?.array as? [BooksCD]
            if let title = books?[indexPath.section].book {
                header.chapterHeaderLabel.text = String(title)
            }
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chapterCell", for: indexPath) as? ChapterCell else { return UICollectionViewCell() }
        
        switch ScriptureController.shared.selectedTestament {
        case TestamentKeys.DaC:
            let sections = ScriptureController.shared.fetchedDoctrine?.sections?.array as? [SectionCD]
            if let section = sections?[indexPath.row].section {
                cell.chapterNumber = Int(section)
            }
        default:
            let books = ScriptureController.shared.fetchedTestament?.books?.array as? [BooksCD]
            if books?[indexPath.section].chapters?.count ?? 0 > indexPath.row {
                let chapters = books?[indexPath.section].chapters?.allObjects as? [ChapterCD]
                if let chapterNumber =  chapters?[indexPath.row].chapter {
                cell.chapterNumber = Int(chapterNumber)
                }
            }
        }
        
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    // MARK: Setup
    func setupMainView() {
        
        self.barButton = self.navigationItem.rightBarButtonItem
        guard let bookmarkButton = self.navigationItem.rightBarButtonItem else { return }
        bookmarkButton.target = self
        bookmarkButton.action = #selector(bookmarkBarButtonTapped)
    }
    
    func setupTestament() {
        
        switch booksSegmentedControl.selectedSegmentIndex {
        case 0: ScriptureController.shared.selectedTestament = TestamentKeys.BoM
        case 1: ScriptureController.shared.selectedTestament = TestamentKeys.PoGP
        case 2: ScriptureController.shared.selectedTestament = TestamentKeys.DaC
        case 3: ScriptureController.shared.selectedTestament = TestamentKeys.NT
        default: ScriptureController.shared.selectedTestament = TestamentKeys.OT
        }
        ScriptureController.shared.change(testament: ScriptureController.shared.selectedTestament ?? TestamentKeys.BoM) { (_) in
        }
        self.collectionView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func booksSegmentedControlValueChanged(_ sender: Any) {
        
        setupTestament()
    }
    
    @objc func bookmarkBarButtonTapped(_ sender: Any) {
        
        if let destinationTestament = BookmarkController.shared.bookmark?.testament,
        let destinationBook = BookmarkController.shared.bookmark?.book,
            let destinationChapter = BookmarkController.shared.bookmark?.chapter {
        ScriptureController.shared.selectedTestament = TestamentKeys.selectedTestament[Int(destinationTestament)]
        ScriptureController.shared.change(testament: ScriptureController.shared.selectedTestament ?? TestamentKeys.BoM) { (_) in
            }
        
        let readingViewController = UIStoryboard(name: "Reader", bundle: nil).instantiateViewController(withIdentifier: "ReadingViewController") as! ReadingViewController
        readingViewController.currentBook = Int(destinationBook)
        readingViewController.currentChapter = Int(destinationChapter)
        
        navigationController?.pushViewController(readingViewController, animated: true)
        } else {
            let alertController = UIAlertController(title: "You haven't set a bookmark", message: nil, preferredStyle: .actionSheet)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ReadingViewController,
            let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell) else { return }
        let book = indexPath.section
        let chapter = indexPath.row
        destinationVC.currentBook = book
        destinationVC.currentChapter = chapter
    }
}
