//
//  CollectionViewModel.swift
//  EthereumAssetViewer
//
//  Created by Arthur Kao on 2022/1/4.
//

import Foundation
import RxSwift
import RxCocoa

class CollectionViewModel {
    
    struct Input {
        let permalinkButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let title: Driver<String?>
        let name: Driver<String?>
        let description: Driver<String?>
        let imageURL: Driver<URL?>
        let permalink: Signal<URL>
    }
    
    var asset: Asset
    
    init(asset: Asset) {
        self.asset = asset
    }
    
    func transform(_ input: Input) -> Output {
        Output(
            title: .just(asset.collection.name),
            name: .just(asset.name),
            description: .just(asset.description),
            imageURL: .just(URL(string: asset.imageUrl)),
            permalink: input.permalinkButtonTap.map { self.asset.permalink }
                .asSignal(onErrorSignalWith: .never())
        )
    }
    
}

