//
//  PrimaryGoalView.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/8/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class PrimaryGoalView: UIView {
    
    @IBOutlet weak var todayButton: UIButton!
    var delegate: PrimaryGoalViewDelegate?
    var daysLeft: Double?
    var chaptersToRead: Double?
    @IBOutlet weak var progressPlantImageView: UIImageView!
    
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
            print("Days left: \(timeLeft)")
            guard let testamentChapters = TestamentKeys.chapters[key], let currentBook = GoalController.shared.primary?.goal?.currentBook, let currentChapter = GoalController.shared.primary?.goal?.currentChapter else { return }
            let chaptersSoFar = calculatePercentageProgress(book: currentBook, chapter: currentChapter)
            
            self.chaptersToRead = (testamentChapters - Double(chaptersSoFar)) / timeLeft
            print(chaptersToRead ?? 0)
            if let chapterCheck = chaptersToRead {
                if chaptersToRead?.isNaN == true || chaptersToRead?.isInfinite == true || chapterCheck <= 0.0 {
                    print("invalidating goal")
                    GoalController.shared.removePrimaryGoal()
                }
            }
        }
        
        guard let testament = GoalController.shared.primary?.goal?.testament,
            let book = GoalController.shared.primary?.goal?.currentBook,
            let chapter = GoalController.shared.primary?.goal?.currentChapter,
            let readingAssignment = chaptersToRead else { setupDailyChaptersGoal(); return }
        ScriptureController.shared.change(testament: TestamentKeys.selectedTestament[Int(testament)] ?? TestamentKeys.BoM) { (_) in
            
            let bookKey = Int(book)
            let chapterKey = Int(chapter)
            guard !readingAssignment.isNaN, !readingAssignment.isInfinite else {
                GoalController.shared.removePrimaryGoal()
                return
            }
            var endIndex = 0
            if readingAssignment <= 1 {
                endIndex = chapterKey
            } else {
                
                endIndex = Int(readingAssignment.rounded()) + (chapterKey - 1)
                if endIndex < 1 {
                    endIndex = 1
                }
            }
            var indexSet = IndexSet(integersIn: chapterKey...endIndex)
            switch testament {
            case 2:
                if endIndex > 137 {  indexSet = IndexSet(integersIn: chapterKey...137) }
                guard let sectionsToBeRead = ScriptureController.shared.fetchedDoctrine?.sections?.objects(at: indexSet) as? [SectionCD] else { return }
                guard let first = sectionsToBeRead.first?.reference, let last = sectionsToBeRead.last?.section, let referenceCheck = sectionsToBeRead.last?.reference, first != referenceCheck else {
                    if let only = sectionsToBeRead.first?.reference {
                        self.todayButton.setTitle("    \(only)    ", for: .normal)
                        GoalController.shared.setCurrentReference(reference: only)
                    }
                    return
                }
                self.todayButton.setTitle("    \(first) - \(last)    ", for: .normal)
                GoalController.shared.setCurrentReference(reference: "\(first) - \(last)")

            default:
                let books = ScriptureController.shared.fetchedTestament?.books?.array as? [BooksCD]
                guard let rangeCheck = books?[bookKey].chapters?.count else { return }
                if endIndex > rangeCheck {
                    endIndex = rangeCheck - 1
                    indexSet = IndexSet(integersIn: chapterKey...endIndex)
                }
                guard let chaptersToBeRead = books?[bookKey].chapters?.objects(at: indexSet) as? [ChapterCD] else { return }
                guard let first = chaptersToBeRead.first?.reference, let last = chaptersToBeRead.last?.chapter, let referenceCheck = chaptersToBeRead.last?.reference, first != referenceCheck else {
                    if let only = chaptersToBeRead.first?.reference {
                        self.todayButton.setTitle("    \(only)    ", for: .normal)
                        GoalController.shared.setCurrentReference(reference: only)
                    }
                    return
                }
                self.todayButton.setTitle("    \(first) - \(last)    ", for: .normal)
                GoalController.shared.setCurrentReference(reference: "\(first) - \(last)")
            }
        }
    }
    
    func setupDailyChaptersGoal() {
        
        guard let dailyChapters = GoalController.shared.primary?.goal?.dailyChapters, let testament = GoalController.shared.primary?.goal?.testament,
            let book = GoalController.shared.primary?.goal?.currentBook,
            let chapter = GoalController.shared.primary?.goal?.currentChapter else { return }
        if dailyChapters > 1 {
            self.chaptersToRead = Double(dailyChapters) - 1
        } else {
            self.chaptersToRead = 1
        }
        _ = calculatePercentageProgress(book: book, chapter: chapter)
        ScriptureController.shared.change(testament: TestamentKeys.selectedTestament[Int(testament)] ?? TestamentKeys.BoM) { (_) in
            let firstIndex = Int(chapter)
            var lastIndex = firstIndex + Int(self.chaptersToRead?.rounded() ?? 0)
            var indexSet = IndexSet(integersIn: firstIndex...lastIndex)
            
            switch testament {
            case 2:
                if lastIndex > 137 {
                    indexSet = IndexSet(integersIn: firstIndex...137)
                }
                guard let sectionsToBeRead = ScriptureController.shared.fetchedDoctrine?.sections?.objects(at: indexSet) as? [SectionCD] else { return }
                guard let first = sectionsToBeRead.first?.reference, let last = sectionsToBeRead.last?.section, let referenceCheck = sectionsToBeRead.last?.reference, first != referenceCheck else {
                    if let only = sectionsToBeRead.first?.reference {
                        self.todayButton.setTitle("    \(only)    ", for: .normal)
                        GoalController.shared.setCurrentReference(reference: only)
                    }
                    return
                }
                self.todayButton.setTitle("    \(first) - \(last)    ", for: .normal)
                GoalController.shared.setCurrentReference(reference: "\(first) - \(last)")
            default:
                let bookKey = Int(book)
                let books = ScriptureController.shared.fetchedTestament?.books?.array as? [BooksCD]
                guard let chapterCheck = books?[bookKey].chapters?.count else { return }
                if lastIndex >= chapterCheck {
                    lastIndex = chapterCheck - 1
                    indexSet = IndexSet(firstIndex...lastIndex)
                }
                guard let chaptersToBeRead = books?[bookKey].chapters?.objects(at: indexSet) as? [ChapterCD] else { return }
                guard let first = chaptersToBeRead.first?.reference, let last = chaptersToBeRead.last?.chapter, let referenceCheck = chaptersToBeRead.last?.reference, first != referenceCheck else {
                    if let only = chaptersToBeRead.first?.reference {
                        self.todayButton.setTitle("    \(only)    ", for: .normal)
                        GoalController.shared.setCurrentReference(reference: only)
                    }
                    return
                }
                self.todayButton.setTitle("    \(first) - \(last)    ", for: .normal)
                GoalController.shared.setCurrentReference(reference: "\(first) - \(last)")
            }
        }
    }
    
    func calculatePercentageProgress(book: Int64, chapter: Int64) -> Int {
        
        var chaptersSoFar = 0
        var percentageCompletion = 0.0
        
        switch GoalController.shared.primary?.goal?.testament {
        case 0:
            chaptersSoFar += (BookOfMormon.chaptersSoFar[book - 1]) ?? 0
            chaptersSoFar += Int(chapter)
            percentageCompletion = (Double(chaptersSoFar) / Double(BookOfMormon.numberOfChapters - 1)) * 100
        case 1:
            chaptersSoFar += (PearlOfGreatPrice.chaptersSoFar[book - 1]) ?? 0
            chaptersSoFar += Int(chapter)
            percentageCompletion = (Double(chaptersSoFar) / Double(PearlOfGreatPrice.numberOfChapters - 1)) * 100
        case 2:
            chaptersSoFar = Int(chapter)
            percentageCompletion = (Double(chaptersSoFar) / 137.0) * 100
        case 3:
            chaptersSoFar += (NewTestament.chaptersSoFar[book - 1]) ?? 0
            chaptersSoFar += Int(chapter)
            percentageCompletion = (Double(chaptersSoFar) / Double(NewTestament.numberOfChapters - 1)) * 100
        case 4:
            chaptersSoFar += (OldTestament.chaptersSoFar[book - 1]) ?? 0
            chaptersSoFar += Int(chapter)
            percentageCompletion = (Double(chaptersSoFar) / Double(OldTestament.numberOfChapters - 1)) * 100
        default: return 0
        }
        
        print("\(percentageCompletion)% complete")
        GoalController.shared.setCompletionPercentage(percentage: percentageCompletion)
        if percentageCompletion >= 100 {
            progressPlantImageView.image = UIImage(named: "6")
        } else if percentageCompletion > 83 {
            progressPlantImageView.image = UIImage(named: "5")
        } else if percentageCompletion > 66 {
            progressPlantImageView.image = UIImage(named: "4")
        } else if percentageCompletion > 50 {
            progressPlantImageView.image = UIImage(named: "3")
        } else if percentageCompletion > 33 {
            progressPlantImageView.image = UIImage(named: "2")
        } else if percentageCompletion > 16 {
            progressPlantImageView.image = UIImage(named: "1")
        } else {
            progressPlantImageView.image = UIImage(named: "0")
        }
        return chaptersSoFar
    }
    
    func disableTodayReadingButton() {
        self.todayButton.setTitle("    Invalid Deadline    ", for: .normal)
        self.todayButton.isEnabled = false
        self.todayButton.backgroundColor = #colorLiteral(red: 1, green: 0.2988327742, blue: 0.217700839, alpha: 1)
        GoalController.shared.removePrimaryGoal()
    }
}

protocol PrimaryGoalViewDelegate: class {
    
    func segueToReader()
}
