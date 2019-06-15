//
//  RadioButton.swift
//  RadioGroup
//
//  Created by Yonat Sharon on 03.02.2019.
//

import UIKit

@IBDesignable open class RadioButton: UIView {
    @IBInspectable open var isSelected: Bool = false {
        didSet {
            selectedCenterView.isHidden = !isSelected
            if isSelected {
                accessibilityTraits.insert(.selected)
            } else {
                accessibilityTraits.remove(.selected)
            }
        }
    }

    @IBInspectable open dynamic var size: CGFloat = 20 {
        didSet {
            constrain(.height, to: size)
            layer.cornerRadius = size / 2
            updateCenterRadius()
            invalidateIntrinsicContentSize()
        }
    }

    @IBInspectable open dynamic var ringWidth: CGFloat = 2 {
        didSet {
            layer.borderWidth = ringWidth
        }
    }

    @IBInspectable open dynamic var ringSpacing: CGFloat = 4 {
        didSet {
            layoutMargins = UIEdgeInsets(top: ringSpacing, left: ringSpacing, bottom: ringSpacing, right: ringSpacing)
            updateCenterRadius()
        }
    }

    @IBInspectable open dynamic var selectedColor: UIColor? {
        didSet {
            selectedCenterView.backgroundColor = selectedColor ?? actualTintColor
        }
    }

    private let selectedCenterView = UIView()

    private func setup() {
        constrain(self, at: .width, to: self, at: .height)
        setContentHuggingPriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        addConstrainedSubview(selectedCenterView, constrain: .topMargin, .bottomMargin, .leftMargin, .rightMargin)
        selectedCenterView.layoutMargins = .zero
        selectedColor = { selectedColor }()
        size = { size }()
        ringWidth = { ringWidth }()
        ringSpacing = { ringSpacing }()
        isSelected = { isSelected }()
        tintColorDidChange()
        isAccessibilityElement = true
        accessibilityLabel = "radio button"
        accessibilityTraits = [.button]
        accessibilityIdentifier = "RadioButton"
    }

    private func updateCenterRadius() {
        selectedCenterView.layer.cornerRadius = (size - layoutMargins.bottom - layoutMargins.top) / 2
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    open override func tintColorDidChange() {
        super.tintColorDidChange()
        let newTint = actualTintColor
        layer.borderColor = newTint.cgColor
        if nil == selectedColor {
            selectedCenterView.backgroundColor = newTint
        }
    }

    open override var intrinsicContentSize: CGSize {
        return CGSize(width: size, height: size)
    }
}

extension UIView {
    var actualTintColor: UIColor {
        var tintedView: UIView? = self
        while let currentView = tintedView, nil == currentView.tintColor {
            tintedView = currentView.superview
        }
        return tintedView?.tintColor ?? .blue
    }
}
