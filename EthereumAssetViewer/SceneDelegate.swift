//
//  SceneDelegate.swift
//  EthereumAssetViewer
//
//  Created by Arthur Kao on 2022/1/4.
//

import UIKit
import class URLNavigator.Navigator

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var assetCoordinator: AssetCoordinator?
    
    let navigator = Navigator()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        registerViewControllers()
        
        assetCoordinator = AssetCoordinator(scene: scene, navigator: navigator)
        assetCoordinator?.start()
    }
}

// MARK: - register view controllers
extension SceneDelegate {
    
    func registerViewControllers() {
        
        navigator.register("app://asset/<address>") { url, values, context in
            let storyboard = UIStoryboard(name: "Layout", bundle: .main)
            guard
                let vc = storyboard.instantiateViewController(withIdentifier: "AssetVC") as? AssetVC,
                let address = values["address"] as? String else {
                    return nil
                }
            vc.viewModel = AssetViewModel(address: address)
            return vc
        }
        
        navigator.register("app://asset/<address>/detail") { url, values, context in
            let storyboard = UIStoryboard(name: "Layout", bundle: .main)
            guard
                let vc = storyboard.instantiateViewController(withIdentifier: "CollectionVC") as? CollectionVC,
                let context = context as? CollectionCoordinator.Context
            else {
                return nil
            }
            vc.viewModel = CollectionViewModel(asset: context.asset)
            vc.openPermalink = context.openPermalink
            return vc
        }
    }
}
