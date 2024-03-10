//
//  FullImageViewController.swift
//  sf_diplom
//
//  Created by Иван on 14.12.2023.
//

import UIKit

class FullImageViewController: UIViewController {
    
    var imageUrls: [URL] = []
    var currentIndex: Int = 0
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupImageView()
        loadImage(at: currentIndex)
        setupSwipeGestures()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.frame = view.bounds
    }
    
    private func loadImage(at index: Int) {
        guard index >= 0 && index < imageUrls.count else { return }
        let imageUrl = imageUrls[index]
        UIView.transition(with: imageView,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                              self.imageView.sd_setImage(with: imageUrl)
                          },
                          completion: nil)
    }
    
    private func setupSwipeGestures() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            if currentIndex < imageUrls.count - 1 {
                currentIndex += 1
                loadImage(at: currentIndex)
            }
        case .right:
            if currentIndex > 0 {
                currentIndex -= 1
                loadImage(at: currentIndex)
            }
        default:
            break
        }
    }
}

