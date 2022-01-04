//
//  AssetVC.swift
//  EthereumAssetViewer
//
//  Created by Arthur Kao on 2022/1/4.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class AssetVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var viewModel: AssetViewModel!
    
    var openCollection: ((String) -> Void)?
    
    lazy var refreshControl: UIRefreshControl = {
        let control =  UIRefreshControl()
        control.triggerVerticalOffset = 60
        return control
    }()
    
    @IBOutlet
    weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.bottomRefreshControl = refreshControl        
        binding()
    }
    
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>> = {
        RxCollectionViewSectionedReloadDataSource { _, collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            return cell
        }
    }()
    
    private func binding() {
        // TODO: bind views
        let output = viewModel.transform(
            AssetViewModel.Input(
                reload: ControlEvent(events: refreshControl.rx.controlEvent(.valueChanged)),
                itemSelected: collectionView.rx.modelSelected(String.self)
            )
        )
        output.collections
            .map {
                [SectionModel(model: "", items: $0)]
            }
            .asDriver()
            .do(onNext: { [weak refreshControl = refreshControl] _ in
                refreshControl?.endRefreshing()
            })
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.openCollection.emit(onNext: openCollection)
                .disposed(by: disposeBag)
    }
    
}

extension AssetVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let width = floor((collectionView.frame.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing) / 2)
        return CGSize(width: width, height: width * 1.2)
    }
}
