//
//  UIView+Extensions.swift
//  TMDB
//
//  Created by Nishant Patel on 7/25/23.
//

import UIKit

extension UIView {
    /// Convenience function to add multiple subviews.
    public func addSubviews(_ views: Set<UIView>) {
        views.forEach(addSubview)
    }
}
