//
//  CustomNavBar.swift
//  BookOfMormon
//
//  Created by Jared Warren on 1/15/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func shadowVisibile(_ bool: Bool) -> Void {
        if bool == true {
            self.setValue(false, forKey: "hidesShadow")
        } else {
            self.setValue(true, forKey: "hidesShadow")
        }
    }
}
