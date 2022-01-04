//
//  CollectionVC.swift
//  EthereumAssetViewer
//
//  Created by Arthur Kao on 2022/1/4.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class CollectionVC: UIViewController {
    
    var viewModel: CollectionViewModel!
    
    let disposeBag = DisposeBag()
    
    var openPermalink: ((URL) -> Void)?
    
    @IBOutlet
    weak var imageView: UIImageView!
    
    weak var imageRatioConstrant: NSLayoutConstraint?
    
    @IBOutlet
    weak var nameLabel: UILabel!
    
    @IBOutlet
    weak var descriptionLabel: UILabel!
    
    @IBOutlet
    weak var permalinkButton: UIButton!
    
    private lazy var imageBinder: Binder<URL?> = {
        Binder(self) { vc, url in
            vc.imageView.kf.setImage(with: url) { result in
                if let size = try? result.get().image.size {
                    vc.imageView.isHidden = false
                    if let existingConstrant = vc.imageRatioConstrant {
                        vc.imageView.removeConstraint(existingConstrant)
                    }
                    vc.imageRatioConstrant = vc.imageView.widthAnchor.constraint(equalTo: vc.imageView.heightAnchor, multiplier: size.width / size.height)
                    vc.imageRatioConstrant?.isActive = true
                } else {
                    vc.imageView.isHidden = true
                }
            }
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        binding()
    }
    
    private func binding() {
        let output = viewModel.transform(.init(permalinkButtonTap: permalinkButton.rx.tap))
        
        output.title.drive(rx.title)
            .disposed(by: disposeBag)
        
        output.imageURL.drive(imageBinder)
            .disposed(by: disposeBag)
        
        output.name.drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.description.drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.permalink
            .emit(onNext: openPermalink)
            .disposed(by: disposeBag)
    }
}
