//
//  UIView + constraints.swift
//  ExtensionKit
//

import UIKit

public extension UIView {
    func constraintToViewCenter(_ view: UIView? = nil, attachToEdges: Bool = true) {
        guard let view = view ?? superview else { return }

        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func constraintToFitInView(_ view: UIView? = nil, attachToEdges: Bool = true, padding: CGFloat = 0) {

        guard let view = view ?? superview else { return }

        translatesAutoresizingMaskIntoConstraints = false

        if attachToEdges {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
                bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
                leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        } else {
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalTo: view.widthAnchor, constant: -2 * padding),
                heightAnchor.constraint(equalTo: view.heightAnchor, constant: -2 * padding),
                centerXAnchor.constraint(equalTo: view.centerXAnchor),
                centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
}
