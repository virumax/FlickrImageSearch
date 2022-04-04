//
//  Entity.swift
//  Entity
//
//  Created by Virendra Ravalji on 03/04/22.
//

import Foundation

// Model

// MARK: - Response
struct Response: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}
