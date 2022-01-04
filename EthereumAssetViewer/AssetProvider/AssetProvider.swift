//
//  AssetProvider.swift
//  EthereumAssetViewer
//
//  Created by Arthur Kao on 2022/1/4.
//

import Foundation
import struct RxSwift.Single

protocol AssetProvider {    
    func fetch(owner: String, offset: Int) -> Single<[Asset]>
}
