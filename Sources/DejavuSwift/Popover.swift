
import Foundation
import UIKit

@MainActor
class Popover: NSObject {
    weak var parentVC: UIViewController!
    weak var vc: UIViewController!
    weak var fromView: UIView?
    weak var arrowColor: UIColor?
    weak var delegate: UIPopoverPresentationControllerDelegate?
    
    var shouldBlur: Bool?
    
    var canDismissOnTouchOutside: Bool?
    
    var then: (() -> Void)?
    
    var blurView: UIVisualEffectView!
    
    static let ANIMATION_DURATION = 0.1
    static let BLUR_OPACTITY = 0.6
    
    static func show(_ vc: UIViewController, parent: UIViewController, from: UIView? = nil, blurred: Bool = false, arrowColor: UIColor? = nil, canDismissOnTouchOutside: Bool = true, permittedArrowDirections: UIPopoverArrowDirection = .any, delegate: UIPopoverPresentationControllerDelegate? = nil) async {
        let popover = Popover()
        popover.delegate = delegate
        popover.parentVC = parent
        popover.vc = vc
        popover.arrowColor = arrowColor
        popover.fromView = from
        popover.canDismissOnTouchOutside = canDismissOnTouchOutside && Dejavu.isIpad()
        popover.shouldBlur = blurred
        PopoverEvent.listen(.EVENT_POPUP_DISMISSED, target: popover, selector: #selector(removeBlur))
        
        await popover.present(permittedArrowDirections) {
            popover.dumbToKeepRetained()
        }
    }
    
    func present(_ directions: UIPopoverArrowDirection, then: @escaping () -> Void) async {
        self.then = then
        await MainActor.run {
            self.vc?.modalPresentationStyle = .popover
            self.parentVC?.present(self.vc, animated: true)
            
            let popoverController = self.vc.popoverPresentationController
            popoverController?.permittedArrowDirections = directions
            if let color = self.arrowColor {
                popoverController?.backgroundColor = color
            }
            popoverController?.delegate = self
            popoverController?.sourceView = self.fromView
            if self.shouldBlur ?? false { self.addBlur() }
        }
    }
    
    func dumbToKeepRetained() {
        
    }
    
    @objc func addBlur() {
        guard Dejavu.isIpad() else { return }
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView?.alpha = 0
        blurView?.frame = parentVC.view.bounds
        blurView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        parentVC.view.addSubview(blurView)
        
        UIView.animate(withDuration: Self.ANIMATION_DURATION) {
            self.blurView?.alpha = Self.BLUR_OPACTITY
        }
    }
    
    
    @objc func removeBlur() {
        UIView.animate(withDuration: Self.ANIMATION_DURATION, animations: { [weak self] in
            self?.blurView?.alpha = 0
        }) { [weak self] _ in
            self?.blurView?.removeFromSuperview()
            self?.then = nil
        }
    }
    
    @MainActor
    deinit {
        PopoverEvent.remove(.EVENT_POPUP_DISMISSED, target: self)
        then = nil
        blurView = nil
    }
    
}

extension Popover: UIPopoverPresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        removeBlur()
        delegate?.presentationControllerDidDismiss?(presentationController)
        then = nil
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        canDismissOnTouchOutside ?? false
    }
}

extension Notification.Name {
    static let EVENT_POPUP_DISMISSED   = Notification.Name("event.dismiss.popup")
    
}

class PopoverEvent {
    static func fire(_ event: NSNotification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: event, object: object, userInfo: userInfo)
    }
    
    static func listen(_ event: NSNotification.Name, target: Any, selector: Selector) {
        NotificationCenter.default.addObserver(target, selector: selector, name: event, object: nil)
    }
    
    static func remove(_ event: NSNotification.Name, target: Any) {
        NotificationCenter.default.removeObserver(target, name: event, object: nil)
    }
}

