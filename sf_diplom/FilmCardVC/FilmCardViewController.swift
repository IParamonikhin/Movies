//
//  MovieViewController.swift
//  sf_diplom
//
//  Created by Иван on 14.12.2023.

import UIKit
import SDWebImage
import AVKit

class FilmCardViewController: UIViewController {

    // MARK: - Properties

    var id: Int?
    var model: Model?
    var filmCard: FilmCardModel?

    private var filmCardVCDelegate: FilmCardVCDelegate?
    private var filmCardVCDataSource: FilmCardVCDataSource?
    
    private var avPlayer: AVPlayer?
    private var avPlayerViewController: AVPlayerViewController?

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    private let likeButton: UIButton = {
        let button = UIButton()

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.layer.cornerRadius = 4
        backgroundView.clipsToBounds = true

        let heartImageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        heartImageView.contentMode = .scaleAspectFit
        heartImageView.tintColor = .white
        
        button.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(button)
        }

        button.addSubview(heartImageView)
        heartImageView.snp.makeConstraints { make in
            make.center.equalTo(button)
            make.width.height.equalTo(25)
        }
        return button
    }()

    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()

    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 40)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .white
        label.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.layer.shadowRadius = 5.0
        label.layer.shadowOpacity = 2.0
        label.layer.masksToBounds = false
        label.layer.shouldRasterize = true
        return label
    }()

    private let origNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .italicSystemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .gray
        return label
    }()

    private let genresLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .lightGray
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .justified
        label.textColor = .white
        return label
    }()

    private let descriptionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
        button.layer.borderColor = UIColor(named: "black")?.cgColor
        button.layer.borderWidth = 1.0
        return button
    }()

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        return collectionView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        filmCardVCDelegate = FilmCardVCDelegate(model: self.model!)
        filmCardVCDataSource = FilmCardVCDataSource(images: filmCard!.images)
        setupUI()
        configure()
    }


}
private extension FilmCardViewController{
    // MARK: - Private Methods
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        setupScrollView()
        setupCoverImageView()
        setupRateLabel()
        setupYearLabel()
        setupLikeButton()
        setupNameLabel()
        setupOrigNameLabel()
        setupGenresLabel()
        setupDescriptionLabel()
        setupDescriptionButton()
        setupCollectionView()
    }
    
    func configure() {
        guard let filmCard = filmCard else { return }
        
        coverImageView.sd_setImage(with: URL(string: filmCard.coverUrl))
        setRateText(rate: filmCard.ratingKinopoisk)
        setYearText(year: filmCard.year)
        setNameText(name: filmCard.nameRu)
        setOrigNameText(name: filmCard.nameOriginal)
        setGenresText(genres: filmCard.genres)
        setDescriptionText(description: filmCard.description)
    }
    
    func setRateText(rate: Double) {
        let fullString = NSMutableAttributedString(string: " ")
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "icon-kp-bw-inv")
        image1Attachment.bounds = CGRect(x: 0, y: -1, width: 20, height: 20)
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: " \(String(rate)) "))
        rateLabel.attributedText = fullString
    }
    
    func setYearText(year: Int) {
        yearLabel.text = " \(String(year)) "
    }
    
    func setNameText(name: String) {
        nameLabel.text = name
    }
    
    func setOrigNameText(name: String) {
        origNameLabel.text = name
    }
    
    func setGenresText(genres: [Genres]) {
        let text = genres.map { $0.genre.capitalized }.joined(separator: ", ")
        genresLabel.text = text
    }
    
    func setDescriptionText(description: String) {
        descriptionLabel.text = description
    }
    
    // MARK: - UI Setup Methods
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.width.height.top.equalTo(self.scrollView)
//            make.width.equalTo(self.scrollView)
            make.centerX.equalTo(scrollView)
            make.bottom.equalTo(scrollView)
        }
    }
    
    func setupCoverImageView() {
        contentView.addSubview(coverImageView)
        coverImageView.snp.makeConstraints { make in
            make.top.right.left.equalTo(contentView)
            make.height.equalTo(coverImageView.snp.width)
        }
    }

    func setupRateLabel() {
        contentView.addSubview(rateLabel)
        rateLabel.snp.makeConstraints { make in
            make.left.top.equalTo(coverImageView).inset(16)
        }
    }
    
    func setupYearLabel() {
        contentView.addSubview(yearLabel)
        yearLabel.snp.makeConstraints { make in
            make.right.top.equalTo(coverImageView).inset(16)
        }
    }
    
    func setupLikeButton() {
        contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.centerX.equalTo(coverImageView)
            make.top.bottom.equalTo(rateLabel)
            make.width.equalTo(likeButton.snp.height)
        }
        likeButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likeButtonTapped))
        likeButton.addGestureRecognizer(tapGesture)
    }
    
    func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(coverImageView.snp.bottom).inset(16)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().inset(5)
        }
    }
    
    func setupOrigNameLabel() {
        contentView.addSubview(origNameLabel)
        origNameLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().inset(5)
        }
    }
    
    func setupGenresLabel() {
        contentView.addSubview(genresLabel)
        genresLabel.snp.makeConstraints { make in
            make.top.equalTo(origNameLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().inset(5)
        }
    }
    
    func setupDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(genresLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().inset(5)
        }
    }
    
    func setupDescriptionButton() {
        contentView.addSubview(descriptionButton)
        descriptionButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(5)
            make.width.equalTo(100)
            make.height.equalTo(25)
        }
        descriptionButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    func setupCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.top.equalTo(descriptionButton.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(5)
        }
        collectionView.register(FilmCardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self.filmCardVCDataSource
        collectionView.delegate = self.filmCardVCDelegate
    }
    
    
    // MARK: - Action Methods
    
    @objc func buttonClicked() {
        let vc = DescriptionViewController()
        vc.descriptionString = filmCard?.description
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self.filmCardVCDelegate
        present(vc, animated: true, completion: nil)
    }
    
    @objc func likeButtonTapped() {
        guard let heartImageView = likeButton.subviews.compactMap({ $0 as? UIImageView }).first else { return }

        heartImageView.tintColor = (heartImageView.tintColor == .white) ? .red : .white
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.2
        animation.fromValue = 0.8
        animation.toValue = 1.25
        animation.autoreverses = true
        heartImageView.layer.add(animation, forKey: "splashAnimation")
    }
}



