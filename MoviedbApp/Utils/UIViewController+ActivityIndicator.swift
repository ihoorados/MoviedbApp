//
//  UIViewController+ActivityIndicator.swift
//  MoviedbApp
//
//  Created by Hoorad on 1/15/25.
//

import UIKit

extension UIViewController {

    func makeActivityIndicator(size: CGSize, style: UIActivityIndicatorView.Style) -> UIActivityIndicatorView {
        let style: UIActivityIndicatorView.Style = style
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.color = .label
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: size)
        return activityIndicator
    }
}
