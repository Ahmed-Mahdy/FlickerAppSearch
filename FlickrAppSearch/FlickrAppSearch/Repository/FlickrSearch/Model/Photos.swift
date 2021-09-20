//
//  Photos.swift
//  FlickrAppSearch
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import Foundation

struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}
