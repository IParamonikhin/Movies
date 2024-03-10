//
//  FilmCardCollectionViewCell.swift
//  sf_diplom
//
//  Created by Иван on 04.01.2024.

import UIKit
import SDWebImage

class FilmCardCollectionViewCell: UICollectionViewCell {
    
    var tapGestureHandler: (() -> Void)?

    
    func configure(url: URL) {
        self.imageView.sd_setImage(with: url)
        imageView.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
}

private extension FilmCardCollectionViewCell {
    
    func initialize() {
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        }
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped() {
        tapGestureHandler?()
    }
}
