//
//  CollectionCoordinator.swift
//  EthereumAssetViewer
//
//  Created by Arthur Kao on 2022/1/4.
//

import UIKit
import URLNavigator

class CollectionCoordinator {
    
    let asset: String
    let navigator: Navigator
    
    init (asset: String, navigator: Navigator) {
        self.asset = asset
        self.navigator = navigator
    }
    
    func start() {
        navigator.push("app://asset/\(asset)/detail")
    }
}
