//
//  TabThree.swift
//  BookOfMormon
//
//  Created by Jared Warren on 12/18/18.
//  Copyright © 2018 Warren. All rights reserved.
//

import UIKit

class TabThree: UIViewController {

    @IBOutlet weak var studyTypeLabel: UILabel!
    let studyTypes = ["Favorites:",
                      "Memorize:",
                      "Impressions:"]
    var currentType = 0 {
        didSet {
            studyTypeLabel.text = studyTypes[self.currentType]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        studyTypeLabel.text = studyTypes[currentType]
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        
        if currentType < 2 {
            currentType += 1
        } else {
            currentType = 0
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
