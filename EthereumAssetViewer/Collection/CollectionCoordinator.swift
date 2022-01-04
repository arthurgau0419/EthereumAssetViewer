//
//  CollectionCoordinator.swift
//  EthereumAssetViewer
//
//  Created by Arthur Kao on 2022/1/4.
//

import UIKit
import URLNavigator

class CollectionCoordinator {
    
    typealias Context = (asset: Asset, openPermalink: ((URL) -> Void))
    
    let owner: String
    let asset: Asset
    let navigator: Navigator
    
    init (owner: String, asset: Asset, navigator: Navigator) {
        self.owner = owner
        self.asset = asset
        self.navigator = navigator
    }
    
    func start() {
        let context: Context = (
            asset,
            { link in
                UIApplication.shared.open(link, options: [:], completionHandler: nil)
            }
        )
        navigator.push("app://asset/\(owner)/detail", context: context)
    }
}
