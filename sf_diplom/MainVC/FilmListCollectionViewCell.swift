//
//  FilmListCollectionViewCell.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.
//

import UIKit
import SnapKit
import SDWebImage

class FilmListCollectionViewCell: UICollectionViewCell {
    
    func configure(film: FilmCellData){
        self.nameLable.text = film.name
        self.rateLable.text = film.rate
        self.yearLable.text = film.year
        self.imageView.sd_setImage(with: film.imgUrl)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let nameLable = UILabel()
    private let rateLable = UILabel()
    private let yearLable = UILabel()
    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
}

private extension FilmListCollectionViewCell{
    
    func initialize(){
        
        let height = contentView.frame.height
        
        contentView.isUserInteractionEnabled = true
        contentView.addSubview(imageView)
        contentView.addSubview(nameLable)
        contentView.addSubview(rateLable)
        contentView.addSubview(yearLable)
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(height * 0.75)
        }
        nameLable.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo((height * 0.25) / 2)
        }
        rateLable.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(nameLable.snp.bottom)
        }
        yearLable.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.top.equalTo(nameLable.snp.bottom)
            make.left.equalTo(rateLable.snp.right)
        }
    }
}
