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
        self.nameLabel.text = film.name
        self.rateLabel.text = film.rate
        self.yearLabel.text = film.year
        self.imageView.sd_setImage(with: film.imgUrl)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let nameLabel = UILabel()
    private let rateLabel = UILabel()
    private let yearLabel = UILabel()
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
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(width)
        }
        contentView.isUserInteractionEnabled = true
        contentView.backgroundColor = UIColor(named: "BackgroundColor")
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = .none
        
        contentView.layer.shadowOffset = CGSizeMake(0, 0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowColor = UIColor(named: "BorderShadowColor")?.cgColor
        contentView.layer.shadowOpacity = 2.5
        contentView.layer.masksToBounds = false
        
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(rateLabel)
        contentView.addSubview(yearLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(8)
            make.left.equalToSuperview().offset(8)
            
            make.height.equalTo(height * 0.85)
        }
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.equalTo(imageView.snp.bottom).offset(3)
//            make.height.equalTo((height * 0.15) / 2)
        }
        nameLabel.textColor = .white
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        nameLabel.lineBreakMode = .byTruncatingTail
        
        rateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.left.top.equalToSuperview().inset(16)
        }
        rateLabel.textColor = .white
        rateLabel.backgroundColor = .black.withAlphaComponent(0.5)
        rateLabel.layer.cornerRadius = 4
        rateLabel.clipsToBounds = true
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.right.top.equalToSuperview().inset(16)
        }
        yearLabel.textColor = .white
        yearLabel.backgroundColor = .black.withAlphaComponent(0.5)
        yearLabel.layer.cornerRadius = 4
        yearLabel.clipsToBounds = true
    }
}
