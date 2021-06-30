//
//  OverlayView.swift
//  OverlayView
//
//  Created by Duc iOS on 30/6/2021.
//

import UIKit
import Stevia

// MARK: - Overlay

private class OverlayWindow: UIWindow {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = UIColor.clear
        windowLevel = .normal
        rootViewController = UIViewController()
    }
}

public class OverlayView: UIView {
    public enum Position {
        case middle, bottom, view(UIView, CGPoint? = nil, directionX: DirectionX = .center, directionY: DirectionY = .down)
    }
    
    public enum BackgroundStyle {
        case dim, clear
    }
    
    public enum DirectionX {
        case left, right, center
    }
    
    public enum DirectionY {
        case up, down
    }
    
    internal init(position: Position,
                  view: UIView,
                  backgroundStyle: BackgroundStyle = .dim,
                  dismissOnTap: Bool = false,
                  onDismiss: (() -> Void)?) {
        self.position = position
        self.view = view
        self.backgroundStyle = backgroundStyle
        self.dismissOnTap = dismissOnTap
        self.onDismiss = onDismiss
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    weak var view: UIView?
    let position: Position
    let backgroundStyle: BackgroundStyle
    let dismissOnTap: Bool
    let onDismiss: (() -> Void)?
    
    func commonInit() {
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        tap.delegate = self
        tap.addTarget(self, action: #selector(ontap(_:)))
        addGestureRecognizer(tap)
    }
    
    @objc func ontap(_ tap: UITapGestureRecognizer) {
        if dismissOnTap { dismiss() }
    }
    
    private func originalPosition() {
        guard let view = view else { return }
        
        switch position {
        case .middle:
            view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        case .bottom:
            view.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        case .view(_, _, let directionX, let directionY):
            switch (directionX, directionY) {
            case (.right, .down):
                view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).concatenating(CGAffineTransform(translationX: -view.bounds.width/2, y: -view.bounds.height/2))
            case (.left, .down):
                view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).concatenating(CGAffineTransform(translationX: view.bounds.width/2, y: -view.bounds.height/2))
            case (.center, .down):
                view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).concatenating(CGAffineTransform(translationX: 0, y: -view.bounds.height/2))
            case (.right, .up):
                view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).concatenating(CGAffineTransform(translationX: -view.bounds.width/2, y: view.bounds.height/2))
            case (.left, .up):
                view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).concatenating(CGAffineTransform(translationX: view.bounds.width/2, y: view.bounds.height/2))
            case (.center, .up):
                view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).concatenating(CGAffineTransform(translationX: 0, y: view.bounds.height/2))
            }
        }
    }
    
    private var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let keyWindow = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }.compactMap { $0 as? UIWindowScene }.first?.windows.filter({ $0.isKeyWindow }).first {
                return keyWindow
            } else {
                return UIApplication.shared.keyWindow
            }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    private var prevWindow: UIWindow?
    private var currentWindow: UIWindow?
    
    @discardableResult
    func show(from: UIView? = nil, duration: TimeInterval = 0.3) -> OverlayView? {
        guard let view = view else { return nil }
        
        prevWindow = keyWindow
        if let prevWindow = prevWindow as? OverlayWindow {
            prevWindow.isHidden = true
        }
        let _from: UIView
        if let from = from {
            _from = from
        } else {
            let overlayWindow = OverlayWindow(frame: UIScreen.main.bounds)
            if #available(iOS 13.0, *) {
                overlayWindow.windowScene = keyWindow?.windowScene
            }
            overlayWindow.isHidden = false
            overlayWindow.makeKeyAndVisible()
            currentWindow = overlayWindow
            _from = overlayWindow.rootViewController!.view
        }
        _from.sv(self)
        fillContainer()
        
        sv(view)
        layoutIfNeeded() // initial position
        
        switch position {
        case .middle:
            view.centerInContainer()
            view.left(>=16)
            view.top(>=16)
        case .bottom:
            view.bottom(0)
            if view.widthConstraint == nil {
                view.left(0).fillHorizontally()
            } else {
                view.left(>=0).centerHorizontally()
            }
        case .view(let v, let p, let directionX, let directionY):
            func layout(point: CGPoint) {
                switch (directionX, directionY) {
                case (.right, .down):
                    view.left(point.x).top(point.y)
                case (.left, .down):
                    view.left(point.x-view.bounds.width).top(point.y)
                case (.center, .down):
                    view.left(point.x-view.bounds.width/2).top(point.y)
                case (.right, .up):
                    view.left(point.x).Bottom == self.Top+point.y
                case (.left, .up):
                    view.left(point.x-view.bounds.width).Bottom == self.Top+point.y
                case (.center, .up):
                    view.left(point.x-view.bounds.width/2).Bottom == self.Top+point.y
                }
            }
            if let p = p {
                layout(point: v.convert(p, to: from))
            } else {
                layout(point: v.convert(CGPoint(x: v.bounds.width/2, y: v.bounds.height), to: from))
            }
        }
        
        layoutIfNeeded() // initial position
        originalPosition()
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        guard let self = self else { return }
                        switch self.backgroundStyle {
                        case .dim: self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                        case .clear: self.backgroundColor = .clear
                        }
                        self.view?.transform = .identity
                       }, completion: nil)
        
        return self
    }
    
    func dismiss(duration: TimeInterval = 0.3,
                 complete: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.backgroundColor = .clear
                        self?.originalPosition()
                       }, completion: { [weak self] in
                        complete?()
                        if $0 { self?.cleanUp() }
                       })
    }
    
    deinit {
        print("===== Deinit class \(NSStringFromClass(classForCoder)) =====")
        cleanUp()
    }
    
    func cleanUp() {
        onDismiss?()
        removeFromSuperview()
        view?.removeFromSuperview()
        if #available(iOS 13, *) {
            currentWindow?.windowScene = nil
        }
        if currentWindow?.isKeyWindow == true {
            prevWindow?.makeKeyAndVisible()
            
            if let prevWindow = prevWindow as? OverlayWindow {
                prevWindow.alpha = 0
                UIView.animate(withDuration: 0.2) {
                    prevWindow.alpha = 1
                }
            }
        }
        prevWindow = nil
        currentWindow?.isHidden = true
        currentWindow = nil
    }
}

extension OverlayView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        touch.view == gestureRecognizer.view
    }
}

public protocol OverlayViewCompatible: AnyObject {
}

public extension OverlayViewCompatible {
    var ov: OverlayViewWrapper<Self> {
        OverlayViewWrapper(self)
    }
}

extension UIView: OverlayViewCompatible {
    private struct AssociatedKeys {
        static var overlayView = "overlayView"
    }
    
    var overlayView: OverlayView? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.overlayView) as? OverlayView }
        set { objc_setAssociatedObject(self, &AssociatedKeys.overlayView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

public struct OverlayViewWrapper<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public extension OverlayViewWrapper where Base: UIView {
    func show(from: UIView? = nil,
              duration: TimeInterval = 0.3,
              position: OverlayView.Position = .middle,
              backgroundStyle: OverlayView.BackgroundStyle = .dim,
              dismissOnTap: Bool = false,
              onDismiss: (() -> Void)? = nil) {
        base.overlayView = OverlayView(position: position,
                                       view: base,
                                       backgroundStyle: backgroundStyle,
                                       dismissOnTap: dismissOnTap,
                                       onDismiss: onDismiss).show(from: from, duration: duration)
    }
    
    func dismiss(duration: TimeInterval = 0.3,
                 complete: (() -> Void)? = nil) {
        base.overlayView?.dismiss(duration: duration, complete: complete)
    }
}