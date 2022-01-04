//
//  AppCoordinator.swift
//  EthereumAssetViewer
//
//  Created by Arthur Kao on 2022/1/4.
//

import UIKit
import URLNavigator

class AssetCoordinator {
    
    let address = "0x19818f44faf5a217f619aff0fd487cb2a55cca65"
    
    let window: UIWindow
    let navigator: Navigator
    
    var collectionCoordinator: CollectionCoordinator?
    
    init(scene: UIWindowScene, navigator: Navigator) {
        self.window = UIWindow(windowScene: scene)
        self.navigator = navigator
    }
    
    func start() {
        window.makeKeyAndVisible()
        guard let assetVC = navigator.viewController(for: "app://asset/\(address)", context: nil) as? AssetVC else { return }
        window.rootViewController = UINavigationController(rootViewController: assetVC)
        assetVC.openCollection = { [weak self] _ in
            self?.openCollection()
        }
    }
    
    func openCollection() {
        collectionCoordinator = CollectionCoordinator(asset: address, navigator: navigator)
        collectionCoordinator?.start()
    }
}
