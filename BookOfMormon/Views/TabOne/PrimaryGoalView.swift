//
//  CurrentGoalView.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/8/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class PrimaryGoalView: UIView {
    
    @IBOutlet weak var todayButton: UIButton!
    var delegate: CurrentGoalViewDelegate?
    var daysLeft: Double?
    var chaptersToRead: Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        calculateGoalStats()
    }
    
    func setupView() {
        
        todayButton.layer.cornerRadius = todayButton.frame.height / 2
        guard let currentReference = GoalController.shared.primary?.goal?.currentReference else { return }
        todayButton.setTitle("    \(currentReference)    ", for: .normal)
    }
    
    @IBAction func todayButtonTapped(_ sender: Any) {
        
        delegate?.segueToReader()
    }
    
    func calculateGoalStats() {
        
        if var timeLeft = GoalController.shared.primary?.goal?.desiredEndDate?.timeIntervalSinceNow,
            let goalTestament = GoalController.shared.primary?.goal?.testament {
            
            let key = Int(goalTestament)
            timeLeft = (timeLeft / 86400).rounded(.down)
            self.daysLeft = timeLeft
            print(timeLeft)
            guard let testamentChapters = TestamentKeys.chapters[key] else { return }
            self.chaptersToRead = testamentChapters / timeLeft
            print(chaptersToRead ?? 0)
        }
        
        guard let testament = GoalController.shared.primary?.goal?.testament,
        let book = GoalController.shared.primary?.goal?.currentBook,
            let chapter = GoalController.shared.primary?.goal?.currentChapter,
        let readingAssignment = chaptersToRead else { return }
        ScriptureController.shared.change(testament: TestamentKeys.selectedTestament[Int(testament)] ?? TestamentKeys.BoM) { (_) in
            
            let bookKey = Int(book)
            let chapterKey = Int(chapter)
            guard !readingAssignment.isNaN, !readingAssignment.isInfinite else { self.todayButton.setTitle("    Invalid Deadline    ", for: .normal); self.todayButton.isEnabled = false; self.todayButton.backgroundColor = #colorLiteral(red: 1, green: 0.2988327742, blue: 0.217700839, alpha: 1); return }
            let end = Int(readingAssignment.rounded()) + chapterKey
            let indexSet = IndexSet(integersIn: chapterKey...end)
            
            switch testament {
            case 2:
                guard let sectionsToBeMemorized = ScriptureController.shared.fetchedDoctrine?.sections?.objects(at: indexSet) as? [SectionCD] else { return }
                guard let first = sectionsToBeMemorized.first?.reference, let last = sectionsToBeMemorized.last?.reference else { return }
                self.todayButton.setTitle("    \(first) - \(last)    ", for: .normal)
            default:
                let books = ScriptureController.shared.fetchedTestament?.books?.array as? [BooksCD]
                guard let chaptersToBeMemorized = books?[bookKey].chapters?.objects(at: indexSet) as? [ChapterCD] else { return }
                guard let first = chaptersToBeMemorized.first?.reference, let last = chaptersToBeMemorized.last?.reference else { return }
                self.todayButton.setTitle("    \(first) - \(last)    ", for: .normal)
            }
        }
    }
}

protocol CurrentGoalViewDelegate: class {
    
    func segueToReader()
}
