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
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup View Methods
    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        ScriptureController.shared.decode(testament: ScriptureController.shared.selectedTestament ?? TestamentKeys.BoM)
    }
    
    // MARK: - CollectionView Data Source Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
    
        return ScriptureController.shared.decodedTestament?.books.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
     return ScriptureController.shared.decodedTestament?.books[section].chapters.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "chapterHeader", for: indexPath) as? ChapterHeader else { return UICollectionReusableView() }
        if let title = ScriptureController.shared.decodedTestament?.books[indexPath.section].book {
            header.chapterHeaderLabel.text = String(title)
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chapterCell", for: indexPath) as? ChapterCell else { return UICollectionViewCell() }
        if ScriptureController.shared.decodedTestament?.books[indexPath.section].chapters.count ?? 0 > indexPath.row {
            if let chapter = ScriptureController.shared.decodedTestament?.books[indexPath.section].chapters[indexPath.row].chapter {
                cell.chapterNumber = chapter
            }
        }
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    // MARK: - Actions
    
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
