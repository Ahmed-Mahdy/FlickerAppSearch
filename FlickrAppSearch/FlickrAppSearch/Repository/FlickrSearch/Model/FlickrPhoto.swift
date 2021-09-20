//
//  FlickrPhoto.swift
//  FlickrAppSearch
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import Foundation

struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int

    var imageURL: String {
        let urlString = String(format: FlickrTarget.imageURL, farm, server, id, secret)
        return urlString
    }
}
