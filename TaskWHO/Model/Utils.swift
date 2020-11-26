//
//  Utils.swift
//  FieldPro
//
//  Created by Ramesh P on 27/12/19.
//  Copyright © 2020 Kaspon Techworks Pvt Limited. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class Utils {
    //NSUserDefault
    static func setPreferenceValue(setValue value : String, ForKey key: String) {
        
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key as String)
    }
    static func getPreferenceValue(ForKey key: String) -> String {
        
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: key as String) {
            return name;
        }
        return "";
    }
    
}

