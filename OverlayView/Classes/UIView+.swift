//
//  UIView+.swift
//  OverlayView
//
//  Created by Duc on 27/08/2021.
//

public extension UIView {
    @discardableResult
    func subviews(_ view: UIView) -> Self {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return self
    }
    
    @discardableResult
    func height(_ height: CGFloat) -> Self {
        addConstraint(NSLayoutConstraint(item: self, attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil, attribute: .height,
                                         multiplier: 1, constant: height))
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat) -> Self {
        addConstraint(NSLayoutConstraint(item: self, attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil, attribute: .width,
                                         multiplier: 1, constant: width))
        return self
    }
    
    @discardableResult
    func size(_ size: CGFloat) -> Self {
        height(size).width(size)
    }
    
    @discardableResult
    func left(_ offset: CGFloat) -> Self {
        guard let superview = superview else { return self }
        leftAnchor.constraint(equalTo: superview.leftAnchor, constant: offset).isActive = true
        return self
    }
    
    @discardableResult
    func left(greaterThanOrEqualTo offset: CGFloat) -> Self {
        guard let superview = superview else { return self }
        leftAnchor.constraint(greaterThanOrEqualTo: superview.leftAnchor, constant: offset).isActive = true
        return self
    }
    
    @discardableResult
    func right(_ offset: CGFloat) -> Self {
        guard let superview = superview else { return self }
        rightAnchor.constraint(equalTo: superview.rightAnchor, constant: offset).isActive = true
        return self
    }
    
    @discardableResult
    func right(greaterThanOrEqualTo offset: CGFloat) -> Self {
        guard let superview = superview else { return self }
        rightAnchor.constraint(greaterThanOrEqualTo: superview.rightAnchor, constant: offset).isActive = true
        return self
    }
    
    @discardableResult
    func top(_ offset: CGFloat) -> Self {
        guard let superview = superview else { return self }
        topAnchor.constraint(equalTo: superview.topAnchor, constant: offset).isActive = true
        return self
    }
    
    @discardableResult
    func top(greaterThanOrEqualTo offset: CGFloat) -> Self {
        guard let superview = superview else { return self }
        topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor, constant: offset).isActive = true
        return self
    }
    
    @discardableResult
    func bottom(_ offset: CGFloat) -> Self {
        guard let superview = superview else { return self }
        bottom(superview.bottomAnchor, offset: offset)
        return self
    }
    
    @discardableResult
    func bottom(greaterThanOrEqualTo offset: CGFloat) -> Self {
        guard let superview = superview else { return self }
        bottomAnchor.constraint(greaterThanOrEqualTo: superview.bottomAnchor, constant: offset).isActive = true
        return self
    }
    
    @discardableResult
    func bottom(_ anchor: NSLayoutYAxisAnchor, offset: CGFloat) -> Self {
        bottomAnchor.constraint(equalTo: anchor, constant: offset).isActive = true
        return self
    }
    
    @discardableResult
    func fillContainer() -> Self {
        guard let superview = superview else { return self }
        leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        return self
    }
    
    @discardableResult
    func centerInContainer() -> Self {
        guard let superview = superview else { return self }
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        return self
    }
    
    @discardableResult
    func centerHorizontally() -> Self {
        guard let superview = superview else { return self }
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        return self
    }
    
    @discardableResult
    func centerVertically() -> Self {
        guard let superview = superview else { return self }
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        return self
    }
    
    var widthConstraint: NSLayoutConstraint? {
        return constraintForView(self, attribute: .width)
    }
    
    func constraintForView(_ v: UIView, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        
        func lookForConstraint(in view: UIView?) -> NSLayoutConstraint? {
            guard let constraints = view?.constraints else {
                return nil
            }
            for c in constraints {
                if let fi = c.firstItem as? NSObject, fi == v && c.firstAttribute == attribute {
                    return c
                } else if let si = c.secondItem as? NSObject, si == v && c.secondAttribute == attribute {
                    return c
                }
            }
            return nil
        }
        
        // Width and height constraints added via widthAnchor/heightAnchors are
        // added on the view itself.
        if (attribute == .width || attribute == .height) {
            return lookForConstraint(in: v.superview) ?? lookForConstraint(in: v)
        }
        
        // Look for constraint on superview.
        return lookForConstraint(in: v.superview)
    }
}
