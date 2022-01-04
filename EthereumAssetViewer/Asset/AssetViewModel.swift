//
//  AssetViewModel.swift
//  EthereumAssetViewer
//
//  Created by Arthur Kao on 2022/1/4.
//

import Foundation
import RxSwift
import RxCocoa

class AssetViewModel {
    
    struct Input {
        let reload: ControlEvent<Void>
        let itemSelected: ControlEvent<Asset>
    }
    
    struct Output {
        let title: Driver<String?>
        let collections: Driver<[Asset]>
        let openCollection: Signal<Asset>
        let isRefreshing: Driver<Bool>
    }
    
    let address: String
    
    let assetProvider: AssetProvider = OpenSeaAssetProvider()
    
    var assets = [Asset]()
    
    init(address: String) {
        self.address = address
    }
    
    func transform(_ input: Input) -> Output {
        
        var current = [Asset]()
        
        let isRefreshing = BehaviorRelay<Bool>(value: false)
        
        let collections = input.reload
            .withLatestFrom(isRefreshing)
            .filter { !$0 }
            .withUnretained(self)
            .flatMap { vm, _ in
                vm.assetProvider.fetch(owner: vm.address, offset: current.count)
                    .do(onSubscribe: {
                        isRefreshing.accept(true)
                    }, onDispose: {
                        isRefreshing.accept(false)
                    })
            }
            .retry()
            .scan(into: []) { assets, newAssets in
                assets.append(contentsOf: newAssets)
            }
            .do(onNext: { current = $0 })
            .asDriver(onErrorDriveWith: .never())
        
        return Output(
            title: .just("List"),
            collections: collections,
            openCollection: input.itemSelected.asSignal(),
            isRefreshing: isRefreshing.asDriver()
        )
    }
}
