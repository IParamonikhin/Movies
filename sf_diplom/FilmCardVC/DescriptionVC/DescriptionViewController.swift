//
//  DescriptionViewController.swift
//  sf_diplom
//
//  Created by Иван on 13.01.2024.
//


import UIKit
import SnapKit

class DescriptionViewController: UIViewController {

    var descriptionString: String?
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .justified
        label.textColor = .white
        return label
    }()
    
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
    private let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()
    
    private let cornerRadius: CGFloat = 20
    private let contentTopOffset: CGFloat = 25
    private let labelVerticalOffset: CGFloat = 10
    private let labelHorizontalOffset: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        addSwipeGesture()
        descriptionLabel.text = descriptionString
    }
    
}

private extension DescriptionViewController {
    
    func initialize() {
        setupViewHierarchy()
        setupConstraints()
    }
    
    func setupViewHierarchy() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        view.addSubview(scrollView)
        view.addSubview(topLine)
        scrollView.addSubview(contentView)
        contentView.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topLine.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
        
        topLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.width.equalTo(75)
            make.height.equalTo(4)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.centerX.equalTo(scrollView)
            make.top.equalTo(scrollView)
            make.bottom.lessThanOrEqualTo(scrollView)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(labelVerticalOffset)
            make.left.equalToSuperview().offset(labelHorizontalOffset)
            make.right.equalToSuperview().inset(labelHorizontalOffset)
            make.bottom.equalToSuperview().inset(labelVerticalOffset)
        }
    }
    
    func addSwipeGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipe() {
        guard scrollView.contentOffset.y <= 0 else {
            return
        }

        scrollView.isScrollEnabled = false
        dismiss(animated: true) { [weak self] in
            self?.scrollView.isScrollEnabled = true
        }
    }
}
