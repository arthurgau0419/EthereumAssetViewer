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
import Kingfisher

class AssetVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var viewModel: AssetViewModel!
    
    var openCollection: ((Asset) -> Void)?
    
    lazy var refreshControl: UIRefreshControl = {
        let control =  UIRefreshControl()
        control.triggerVerticalOffset = 60
        return control
    }()
    
    private lazy var refreshBinder: Binder<Bool> = {
        Binder(refreshControl) { refreshControl, isRefreshing in
            isRefreshing ? refreshControl.beginRefreshing() : refreshControl.endRefreshing()
        }
    }()
    
    @IBOutlet
    weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.bottomRefreshControl = refreshControl        
        binding()
    }
    
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<String, Asset>> = {
        RxCollectionViewSectionedReloadDataSource { _, collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AssetCell
            cell.label.text = model.name
            cell.imageView.kf.setImage(with: URL(string: model.imageUrl))
            return cell
        }
    }()
    
    private func binding() {
        let output = viewModel.transform(
            AssetViewModel.Input(
                reload: ControlEvent(events: refreshControl.rx.controlEvent(.valueChanged).filter { self.refreshControl.isRefreshing }.startWith(())),
                itemSelected: collectionView.rx.modelSelected(Asset.self)
            )
        )
        
        output.title
            .drive(rx.title)
            .disposed(by: disposeBag)
        
        output.collections
            .map {
                [SectionModel(model: "", items: $0)]
            }
            .asDriver().drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.openCollection.emit(onNext: openCollection)
                .disposed(by: disposeBag)
                
        output.isRefreshing
                .drive(refreshBinder)                
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
