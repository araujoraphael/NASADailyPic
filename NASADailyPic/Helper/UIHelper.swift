//
//  UIHelper.swift
//  NASADailyPic
//
//  Created by Raphael Araújo on 2018-04-13.
//  Copyright © 2018 Raphael Araújo. All rights reserved.
//

import Foundation

func performOnMainQueue(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
