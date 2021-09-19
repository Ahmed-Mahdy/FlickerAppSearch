//
//  FlickrPhoto.swift
//  FlickrAppSearch
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import Foundation

struct FlickrPhoto: Codable {

    let farm : Int
    let id : String

    let isfamily : Int
    let isfriend : Int
    let ispublic : Int

    let owner: String
    let secret : String
    let server : String
    let title: String

    var imageURL: String {
        let urlString = String(format: FlickrTarget.imageURL, farm, server, id, secret)
        return urlString
    }
}
