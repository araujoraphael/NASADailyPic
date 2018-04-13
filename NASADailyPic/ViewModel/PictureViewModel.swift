//
//  PictureViewModel.swift
//  NASADailyPic
//
//  Created by Raphael Araújo on 2018-04-12.
//  Copyright © 2018 Raphael Araújo. All rights reserved.
//

import Foundation

enum MediaType: String { case image = "image", video = "video" }

struct PictureViewModel {
    var url: String
    var title: String
    var explanation: String?
    var mediaType: MediaType
}
