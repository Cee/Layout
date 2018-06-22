//
//  TestViewController.swift
//  Layout
//
//  Created by Cee on 6/22/18.
//  Copyright © 2018 PerfectFreeze. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    private let stackView: UIStackView
    private let aView: UIStackView
    private let bView = UIView()

    private let button1 = UIButton(type: .custom)
    private let button2 = UIButton(type: .custom)
    private let button3 = UIButton(type: .custom)

    private var selected: UIButton? = nil

    // MARK: - Initializer
    required init() {
        aView = UIStackView(arrangedSubviews: ([button1, button2, button3] as [UIView?]).compactMap { $0 })
        aView.axis = .horizontal
        aView.alignment = .fill
        aView.distribution = .fillEqually

        bView.backgroundColor = .blue

        stackView = UIStackView(arrangedSubviews: ([aView, bView] as [UIView?]).compactMap { $0 })
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        super.init(nibName: nil, bundle: nil)

        reset()
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(stackView)

        setupSubviewConstraints()
        updateButtons(true)
    }

    // MARK: - Layout
    private func setupSubviewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        aView.translatesAutoresizingMaskIntoConstraints = false
        bView.translatesAutoresizingMaskIntoConstraints = false

        // Stack view
        let stackViewTopConstraint = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        stackViewTopConstraint.priority = UILayoutPriority.defaultHigh
        stackViewTopConstraint.isActive = true

        let attributes: [NSLayoutAttribute] = [.top, .bottom, .left, .right]
        attributes.forEach { attribute in
            NSLayoutConstraint.pinItem(stackView, toItem: view, attribute: attribute).isActive = true
        }
    }

    // MARK - Actions
    @objc func didPressButton(_ sender: UIButton) {
        updateState(sender)
    }

    private func reset() {
        [button1, button2, button3].forEach { button in
            button.setTitle("X", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(TestViewController.didPressButton(_:)), for: .touchUpInside)
        }
        selected = nil
    }

    private func updateState(_ current: UIButton) {
        if selected == current {
            reset()
        } else {
            selected?.setTitle("X", for: .normal)
            current.setTitle("O", for: .normal)
            selected = current
        }

        updateButtons(selected == nil)
    }

    private func updateButtons(_ value: Bool) {
        func layout() {
            bView.isHidden = !value // THIS LINE
            view.setNeedsUpdateConstraints()
            view.layoutIfNeeded()
        }

        UIView.animate(withDuration: 0.1, animations: layout)
    }
}

/// Extension for NSLayoutConstraint
extension NSLayoutConstraint {
    static func pinItem(_ item: UIView, toItem: UIView, attribute: NSLayoutAttribute) -> NSLayoutConstraint {
        return NSLayoutConstraint.init(item: item, attribute: attribute, relatedBy: .equal, toItem: toItem, attribute: attribute, multiplier: 1.0, constant: 0)
    }
}
