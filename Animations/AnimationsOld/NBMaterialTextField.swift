//
//  NBMaterialTextField.swift
//  UISharedDesign
//
//  Created by Rishu on 6/28/18.
//  Copyright © 2018 NedBank. All rights reserved.
//

import UIKit
//import RxSwift
//import RxCocoa

open class NBMaterialTextField: UITextField {
   /*
    private var fillState = NBMaterialTextControlState.empty
    
    // MARK: - Configuration
    @IBInspectable open var isEditingEnabled: Bool = true
    
    @IBInspectable open var isEnableHelperText: Bool = false
    
    @IBInspectable open var accessoryImage: UIImage? {
        didSet { setupAccessoryContainer() }
    }
    
    // MARK: - Internal
    var tapTrigger = PublishSubject<Void>()
    var accessoryTapTrigger = PublishSubject<Void>()
    var returnTapTrigger = PublishSubject<Void>()
    var hideBottomView: Bool = false
    
    // Set true if Helper text and error text should co-exist based on validation.
    public var showHelperWithErrorOnFocus: Bool = false

    // MARK: - Delegate
    fileprivate weak var proxyDelegate: UITextFieldDelegate?
    private var headerTitleTrailingConstraint: CGFloat = 0
    private var accessoryBtn: UIButton?
    
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'materialButtonType' instead.")
    @IBInspectable var themeAdaptor: UInt = 0 {
        willSet {
            theme = NBTheme(rawValue: newValue) ?? .default
        }
    }
    
    public var errorMessage: String? {
        didSet {
            errorIconView?.isHidden = (errorMessage == nil)
            updateUI()
        }
    }

    @IBInspectable
    public var helperText: String? {
        didSet {
            updateUI()
        }
    }
    
    internal var style: NBMaterialTextControlStyleType = Style.default {
        didSet {
            updateUI()
        }
    }
    
    open var theme: NBTheme = .default {
        didSet {
            style = theme.getStyle()
            isReadOnly = (theme == .readonly || theme == .readonlyGreen)
        }
    }
    
    // MARK: - Lifecycle
    var isSetUp = false
    lazy var setupOnce: () -> Void = {
        defer {
            self.updateUI()
        }
        self.setup()
        self.isSetUp = true
        return {}
    }()
    
    open var headerTitle: String? {
        get { return headerValue }
        set { headerValue = newValue }
    }
        
    private var headerValue: String? {
        didSet { updateUI() }
    }
    
    open override var text: String? {
        get {
            return super.text
        }
        set {
            super.text = newValue
            updateFillState()
            updateUI()
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            if !isReadOnly {
                let tempTheme: NBTheme = isEnabled ? theme : .disable
                style = tempTheme.getStyle()
            }
        }
    }
    
    open override var delegate: UITextFieldDelegate? {
        get { return proxyDelegate }
        set { proxyDelegate = newValue }
    }
    
    @IBInspectable open var isReadOnly: Bool = false {
        didSet {
            isEditingEnabled = !isReadOnly
        }
    }
    
    @IBInspectable var fontSize : CGFloat = 20 {
        didSet {
            self.font = FontConstants.defaultRegularFontWithSize(size: fontSize)
        }
    }
    
    // MARK: - Private
    private var topPlacehoderLabel: UILabel!
    private var bottomPlacehoderLabel: UILabel?
    private var errorIconView: UIImageView?
    
    @IBInspectable open var infoTopSpacing: CGFloat = 0
    @IBInspectable open var infoHeight: CGFloat = 20
    @IBInspectable open var leadingSpace: CGFloat = 15
    @IBInspectable open var textAreaMargin: CGFloat = 7.5
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public var headerTitleTrailingConstant: CGFloat {
        get {
            return self.headerTitleTrailingConstraint
        }
        set {
            self.headerTitleTrailingConstraint = newValue
            if topPlacehoderLabel != nil {
                topPlacehoderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: headerTitleTrailingConstraint).isActive = true
            }
        }
    }
    
    fileprivate func commonInit() {
        super.placeholder = nil
        self.borderStyle = .none
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        setupOnce()
    }
    
    // MARK: - Setup
    internal func setup() {
        setupTopPlacehoderLabel()
        setupObservers()
        if !isReadOnly || !hideBottomView {
            setupBottomPlacehoderLabel()
        }
        
        clipsToBounds = false
        super.delegate = self
    }
    
    private func setupTopPlacehoderLabel() {
        topPlacehoderLabel = UILabel(frame: .zero)
        topPlacehoderLabel.font = FontConstants.defaultRegularFontWithSize(size: 14)
        topPlacehoderLabel.textColor = style.headerTint
        topPlacehoderLabel.adjustsFontSizeToFitWidth = true
        topPlacehoderLabel.isUserInteractionEnabled = true
        topPlacehoderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topPlacehoderLabel)
        
        topPlacehoderLabel.topAnchor.constraint(equalTo: topAnchor, constant: infoTopSpacing).isActive = true
        topPlacehoderLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topPlacehoderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: headerTitleTrailingConstraint).isActive = true
        topPlacehoderLabel.heightAnchor.constraint(equalToConstant: infoHeight).isActive = true
    }
    
    private func embedBottomViewsToStack() {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.fill
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 5
        if let errorIconView = errorIconView {
            stackView.addArrangedSubview(errorIconView)
        }
        if let bottomPlacehoderLabel = bottomPlacehoderLabel {
            stackView.addArrangedSubview(bottomPlacehoderLabel)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: infoTopSpacing).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: infoHeight).isActive = true
    }
    
    private func setupBottomPlacehoderLabel() {
        let errorIcon = theme == .green ? R.image.customControls.iconWhiteError() : R.image.customControls.iconRedError()
        errorIconView = UIImageView(image: errorIcon)
        errorIconView?.isHidden = true
        errorIconView?.isUserInteractionEnabled = true
        errorIconView?.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)

        bottomPlacehoderLabel = UILabel(frame: .zero)
        bottomPlacehoderLabel?.font = FontConstants.defaultRegularFontWithSize(size: 14)
        bottomPlacehoderLabel?.adjustsFontSizeToFitWidth = true
        bottomPlacehoderLabel?.isUserInteractionEnabled = true
        bottomPlacehoderLabel?.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        
        embedBottomViewsToStack()
    }
    
    private func setupAccessoryContainer() {
        if let image = accessoryImage {
            rightViewMode = .always
            accessoryBtn = UIButton()
            accessoryBtn?.addTarget(self, action: #selector(accessoryBtnTapped), for: .touchUpInside)
            rightView = accessoryBtn
            accessoryBtn?.setImage(image, for: .normal)
            accessoryBtn?.translatesAutoresizingMaskIntoConstraints = false
            addSubview(accessoryBtn!)
            
            let height = self.textEditingRect(forBounds: bounds).height
            accessoryBtn?.heightAnchor.constraint(equalToConstant: height).isActive = true
            accessoryBtn?.widthAnchor.constraint(equalToConstant: height).isActive = true
        } else {
            accessoryBtn?.removeFromSuperview()
            rightViewMode = .never
            rightView = nil
        }
    }

    private func setupObservers() {
        addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
    }
    
    // MARK: - Observers
    @objc func didBeginEditing() {
        fillState = .focused
        errorIconView?.isHidden = true
        errorMessage = nil
        updateUI()
    }
    
    @objc func didEndEditing() {
        fillState = isEmpty ? .empty : .filled
        updateUI()
    }
    
    private func updateFillState() {
        if isFirstResponder {
            fillState = .focused
        } else {
            fillState = isEmpty ? .empty : .filled
        }
    }
    
    // MARK: - update style
    private func updateUI() {
        guard self.isSetUp else { return }
        if self.text?.contains("\n") ?? false {
            self.text = self.text?.replacingOccurrences(of: "\n", with: " ")
            return
        }
        
        topPlacehoderLabel.text = headerValue
        topPlacehoderLabel.textColor = style.headerTint
        updateBottomLabelText()
        
        self.tintColor = style.tintColor
        self.textColor = style.textColor
    
        self.setNeedsDisplay()
        
        if theme == .greenCurrency {
            self.font = FontConstants.defaultThinFontWithSize(size: 40)
        }
    }
    
    private func updateBottomLabelText() {
        switch fillState {
        case .focused:
            if let errorText = errorMessage, showHelperWithErrorOnFocus == true {
                bottomPlacehoderLabel?.textColor = style.errorMessageColor
                bottomPlacehoderLabel?.text = errorText
            } else if isEnableHelperText, let text = helperText, showHelperWithErrorOnFocus == true {
                bottomPlacehoderLabel?.textColor = style.editingMessageTint
                bottomPlacehoderLabel?.text = text
            } else {
                bottomPlacehoderLabel?.textColor = style.editingMessageTint
                bottomPlacehoderLabel?.text = isEnableHelperText ? (helperText ?? R.string.localizable.textfieldTypeSomething()) :""
            }
        default:
            if let errorText = errorMessage {
                bottomPlacehoderLabel?.textColor = style.errorMessageColor
                bottomPlacehoderLabel?.text = errorText
            } else if isEnableHelperText, let text = helperText {
                bottomPlacehoderLabel?.textColor = style.editingMessageTint
                bottomPlacehoderLabel?.text = text
            } else {
                bottomPlacehoderLabel?.text = ""
            }
        }
    }
    
    // MARK: Custom layout overrides
    internal func textEditingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        if isReadOnly || theme == .greenCurrency {
            rect.origin.y += infoHeight + textAreaMargin
            rect.size.height -= infoHeight + textAreaMargin
        } else {
            rect.origin.x += leadingSpace
            rect.origin.y += infoHeight + textAreaMargin
            rect.size.height -= 2*(infoHeight + textAreaMargin)
            rect.size.width -= leadingSpace
        }
        
        return rect
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = textEditingRect(forBounds: super.textRect(forBounds: bounds))
        return rect
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = textEditingRect(forBounds: super.textRect(forBounds: bounds))
        return rect
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if let view = hitView, view.isKind(of: UILabel.self) {
            if (self.isFirstResponder) {
                self.resignFirstResponder()
            }
            return nil
        }
        return hitView
    }
    
    open override func draw(_ rect: CGRect) {
        let lineWidth = style.borderWidth(forState: fillState)
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.origin.x + lineWidth, y: self.bounds.height - infoHeight - textAreaMargin))
        path.addLine(to: CGPoint(x: self.bounds.width - lineWidth, y: self.bounds.height - infoHeight - textAreaMargin))
        if theme != .lineField {
            path.addLine(to: CGPoint(x: self.bounds.width - lineWidth, y: infoHeight + textAreaMargin))
            path.addLine(to: CGPoint(x: self.bounds.origin.x + lineWidth, y: infoHeight + textAreaMargin))
        }
        path.close()
        
        path.lineWidth = lineWidth
        path.lineCapStyle = .square
        if !self.isEnabled && fillState == .filled {
            ColorConstants.disableLightGreyColor.setStroke()
            path.stroke()
        } else {
            if let message = errorMessage, !message.isEmpty {
                style.errorMessageColor.setStroke()
            } else {
                style.states[fillState]?.color.setStroke()
            }
            path.stroke()
        }
    }
    
    @objc private func accessoryBtnTapped() {
        accessoryTapTrigger.onNext(())
    }
}

public extension UITextField {
    var isEmpty: Bool { return text?.isEmpty ?? true }
}

extension NBMaterialTextField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tapTrigger.onNext(())
        return isEditingEnabled && (proxyDelegate?.textFieldShouldBeginEditing?(self) ?? true)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        proxyDelegate?.textFieldDidBeginEditing?(self)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return proxyDelegate?.textFieldShouldEndEditing?(self) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        proxyDelegate?.textFieldDidEndEditing?(self)
    }
    
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        proxyDelegate?.textFieldDidEndEditing?(self, reason: reason)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return proxyDelegate?.textField?(self, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return proxyDelegate?.textFieldShouldClear?(self) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard proxyDelegate?.textFieldShouldReturn?(self) ?? true else {
            return false
        }
        
        returnTapTrigger.onNext(())
        return true
    }
 */
}
