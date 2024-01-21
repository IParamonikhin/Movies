//
//  FilmListCollectionViewCell.swift
//  sf_diplom
//
//  Created by Иван on 15.12.2023.
//

import UIKit
import SnapKit
import SDWebImage
import MarqueeLabel

class FilmListCollectionViewCell: UICollectionViewCell {
    
    private let nameLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.trailingBuffer = 30
        return label
    }()
    private let rateLabel = UILabel()
    private let yearLabel = UILabel()
    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(film: FilmObject) {
        let filmCellData = film.convertToFilmCellData()
        nameLabel.text = filmCellData.name
        rateLabel.text = " \(filmCellData.rate) "
        yearLabel.text = " \(filmCellData.year) "
        imageView.sd_setImage(with: filmCellData.imgUrl)
    }
}
private extension FilmListCollectionViewCell {

    // Constants
    private struct Constants {
        static let contentInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        static let cornerRadius: CGFloat = 10.0
        static let borderWidth: CGFloat = 1.0
        static let shadowOffset = CGSize(width: 0, height: 0)
        static let shadowRadius: CGFloat = 5.0
        static let shadowOpacity: Float = 2.5
    }

    func initialize() {
        configureAppearance()
        setupConstraints()
    }

    func configureAppearance() {
        contentView.backgroundColor = UIColor(named: "BackgroundColor")
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.borderWidth = Constants.borderWidth
        contentView.layer.borderColor = UIColor(named: "BorderShadowColor")?.cgColor
        contentView.layer.shadowOffset = Constants.shadowOffset
        contentView.layer.shadowRadius = Constants.shadowRadius
        contentView.layer.shadowColor = UIColor(named: "BorderShadowColor")?.cgColor
        contentView.layer.shadowOpacity = Constants.shadowOpacity
        contentView.layer.masksToBounds = false

        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(rateLabel)
        contentView.addSubview(yearLabel)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.layer.masksToBounds = true
        
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        nameLabel.lineBreakMode = .byTruncatingTail
        
        rateLabel.textColor = .white
        rateLabel.backgroundColor = .black.withAlphaComponent(0.5)
        rateLabel.layer.cornerRadius = 4
        rateLabel.clipsToBounds = true
        
        yearLabel.textColor = .white
        yearLabel.backgroundColor = .black.withAlphaComponent(0.5)
        yearLabel.layer.cornerRadius = 4
        yearLabel.clipsToBounds = true
    }

    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.contentInsets)
        }

        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right)
            make.left.equalTo(contentView.snp.left)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.85)
        }

        nameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.top.equalTo(imageView.snp.bottom).offset(5)
        }

        rateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.top.equalToSuperview().inset(8)
        }

        yearLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.right.top.equalToSuperview().inset(8)
        }
    }
}
