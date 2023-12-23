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
        let width = contentView.frame.width
        
        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(width)
        }
        contentView.isUserInteractionEnabled = true
        contentView.backgroundColor = UIColor(named: "BackgroundColor")
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = .none//UIColor(named: "BorderShadowColor")?.cgColor
        
        contentView.layer.shadowOffset = CGSizeMake(0, 0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowColor = UIColor(named: "BorderShadowColor")?.cgColor
        contentView.layer.shadowOpacity = 2.5
        contentView.layer.masksToBounds = false
        
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLable)
        contentView.addSubview(rateLable)
        contentView.addSubview(yearLable)
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(height * 0.85)
        }
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        nameLable.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(4)
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo((height * 0.15) / 2)
        }
        nameLable.textColor = .white
        rateLable.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(4)
            make.top.equalTo(nameLable.snp.bottom)
        }
        rateLable.textColor = .white
        yearLable.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(4)
            make.top.equalTo(nameLable.snp.bottom)
            make.left.equalTo(rateLable.snp.right)
        }
        yearLable.textColor = .white
    }
}
