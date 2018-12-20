//
//  TabOne.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/15/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class TabOne: UIViewController {
    
    // MARK: - Outlets and Properties
    @IBOutlet weak var todayReadingButton: UIButton!
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup View Methods
    func setupButtons() {
        
        todayReadingButton.layer.cornerRadius = todayReadingButton.frame.height/2
        todayReadingButton.layer.borderWidth = 1
        todayReadingButton.layer.borderColor = UIColor.black.cgColor
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? ReadingViewController else { return }
        destinationVC.currentBook = ScriptureController.shared.currentBook
        destinationVC.currentChapter = ScriptureController.shared.currentChapter
    }
}
