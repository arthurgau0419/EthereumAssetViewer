//
//  Models.swift
//  EthereumAssetViewer
//
//  Created by Arthur Kao on 2022/1/4.
//

import Foundation

struct Asset: Decodable {
    let id: Int
    let imageUrl: String
    let name: String?
    let description: String?
    let permalink: URL
    let collection: Collection
}

struct Collection: Decodable {
    let name: String
}
