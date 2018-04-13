//
//  Picture.swift
//  NASADailyPic
//
//  Created by Raphael Araújo on 2018-04-12.
//  Copyright © 2018 Raphael Araújo. All rights reserved.
//

import Foundation

struct Picture: Codable {
    let explanation: String?
    let url: String
    let title: String
    let media_type: String
}
