////
////  MaterialButton.swift
////  NedBankApp
////
////  Created by przemyslaw.wosko on 26/07/2017.
////  Copyright © 2017 NedBank. All rights reserved.
////
//
//import UIKit
////import RxSwift
////import RxCocoa
//
//@objc public enum NBMaterialButtonType: UInt {
//    case primary = 0
//    case secondary
//    case secondary_reverted
//    case primary_reverted
//    case other
//}
//
//final public class NBMaterialButton: UIButton {
//    
//    public var loaderActive: Bool = false {
//        didSet {
//            if loaderActive {
//                startAnimating()
//            } else {
//                stopAnimating()
//            }
//            isUserInteractionEnabled = !loaderActive
//        }
//    }
//    
//    public var materialButtonType: NBMaterialButtonType = .primary {
//        didSet {
//            updateUI()
//        }
//    }
//    
//    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'materialButtonType' instead.")
//    @IBInspectable var materialButtonTypeAdaptor: UInt = 0 {
//        willSet {
//            self.materialButtonType = NBMaterialButtonType(rawValue: newValue) ?? .primary
//        }
//    }
//    
//    @IBInspectable public var fontSize : CGFloat = 18 {
//        didSet {
//            titleLabel?.font = FontConstants.defaultMediumFontWithSize(size: fontSize)
//        }
//    }
//    
//    override public var isHighlighted: Bool {
//        get { return super.isHighlighted }
//        set {
//            super.isHighlighted = newValue
//            updateUI()
//        }
//    }
//    
//    @IBInspectable public var cornerSize: CGFloat = 4 {
//        didSet {
//            layer.cornerRadius = cornerSize
//        }
//    }
//    
//    private lazy var indicator: MaterialLoader! = {
//        let indicator = MaterialLoader()
//        indicator.state = MaterialLoader.State(tint: ColorConstants.themeColor, loaderColor: self.materialButtonType == .primary ? .white : self.tintColor)
//        indicator.loaderSize = self.frame.height - 20
//        indicator.configure()
//        indicator.isHidden = true
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        return indicator
//    }()
//    
//    private var isAnimating: Bool = false
//    
//    override public var isEnabled: Bool {
//        get { return super.isEnabled }
//        set {
//            super.isEnabled = newValue
//            updateUI()
//        }
//    }
//    
//    private var storedBackgroundColor: UIColor?
//    
//    public override func awakeFromNib() {
//        super.awakeFromNib()
//        configureSpinner()
//    }
//    
//    internal func updateUI( ) {
//        layer.masksToBounds = true
//        layer.cornerRadius = cornerSize
//        
//        switch self.materialButtonType {
//        case .primary:
//            backgroundColor = self.isHighlighted ? ColorConstants.highlightedButtonGreen : (self.isEnabled ? ColorConstants.kellyGreenDark : (loaderActive ? ColorConstants.kellyGreenDark : ColorConstants.disbaledButtonGray))
//            tintColor = ColorConstants.whiteNormal
//
//        case .secondary_reverted:
//            backgroundColor = self.isHighlighted ? ColorConstants.kellyGreenDark : UIColor.clear
//            layer.borderWidth = self.isHighlighted ? 0.0 : 2.0
//            layer.borderColor = self.isEnabled ? ColorConstants.whiteNormal.withAlphaComponent(1.0).cgColor : ColorConstants.whiteNormal.withAlphaComponent(0.3).cgColor
//            tintColor = self.isEnabled ? ColorConstants.whiteNormal.withAlphaComponent(1.0) : (loaderActive ? ColorConstants.whiteNormal.withAlphaComponent(1.0) : ColorConstants.whiteNormal.withAlphaComponent(0.3))
//            self.setTitleColor(ColorConstants.whiteNormal.withAlphaComponent(1.0), for: .highlighted)
//
//        case .secondary:
//            backgroundColor = self.isHighlighted ? ColorConstants.highlightedButtonGreen : UIColor.clear
//            layer.borderWidth = self.isHighlighted ? 0.0 : 2.0
//            layer.borderColor = self.isEnabled ? ColorConstants.kellyGreenDark.cgColor  : (loaderActive ? ColorConstants.kellyGreenDark.cgColor : ColorConstants.disbaledButtonGray.cgColor )
//            tintColor = self.isEnabled ? ColorConstants.kellyGreenDark : (loaderActive ? ColorConstants.kellyGreenDark : ColorConstants.disbaledButtonGray)
//            self.setTitleColor(ColorConstants.whiteNormal.withAlphaComponent(1.0), for: .highlighted)
//            
//        case .primary_reverted:
//            backgroundColor = self.isEnabled ? ColorConstants.whiteNormal.withAlphaComponent(1.0) : (loaderActive ? ColorConstants.whiteNormal.withAlphaComponent(1.0) : ColorConstants.whiteNormal.withAlphaComponent(0.3))
//            tintColor = self.isEnabled ? ColorConstants.kellyGreenDark : (loaderActive ? ColorConstants.kellyGreenDark : ColorConstants.whiteNormal.withAlphaComponent(0.3))
//            self.setTitleColor(ColorConstants.highlightedRevertedGreen.withAlphaComponent(1.0), for: .highlighted)
//            
//        default:
//            backgroundColor = UIColor.clear
//            tintColor = ColorConstants.whiteNormal
//        }
//        titleLabel?.font = FontConstants.defaultMediumFontWithSize(size: fontSize)
//    }
//    
//    private func configureSpinner() {
//        addSubview(indicator)
//        
//        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//    }
//    
//    private func stopAnimating() {
//        setTitleColor(tintColor, for: .normal)
//        indicator.isHidden = true
//        isUserInteractionEnabled = false
//        indicator.isLoading = false
//    }
//    
//    private func startAnimating() {
//        setTitleColor(.clear, for: .normal)
//        indicator.isHidden = false
//        indicator.isLoading = true
//    }
//    
//}
//
//public extension Reactive where Base: NBMaterialButton {
//    public var loader: ControlProperty<Bool> {
//        return UIControl.valuePublic(control: base, getter: { button in
//            button.loaderActive
//        }, setter: { button, value in
//            button.loaderActive = value
//        })
//    }
//    
//    public var enabled: ControlProperty<Bool> {
//        return UIControl.valuePublic(control: base, getter: { button in
//            button.isEnabled
//        }, setter: { button, value in
//            button.isEnabled = value
//            button.updateUI()
//        })
//    }
//}
