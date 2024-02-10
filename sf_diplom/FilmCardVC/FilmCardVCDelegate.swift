//
//  FilmCardVCDelegate.swift
//  sf_diplom
//
//  Created by Иван on 04.01.2024.
//

import Foundation
import UIKit

class FilmCardVCDelegate: NSObject, UICollectionViewDelegateFlowLayout{
   
    var model: Model!
    
    init(model: Model) {
        self.model = model
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 10
        let height = 250
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }

}

extension FilmCardVCDelegate: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
class HalfScreenPresentationController: UIPresentationController {
    private var visualEffectView: UIVisualEffectView?
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return CGRect.zero }
        let height = containerView.bounds.height / 2.0
        return CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        let blurEffect = UIBlurEffect(style: .light)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView?.frame = containerView?.bounds ?? CGRect.zero
        containerView?.addSubview(visualEffectView!)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        visualEffectView?.removeFromSuperview()
    }
}
