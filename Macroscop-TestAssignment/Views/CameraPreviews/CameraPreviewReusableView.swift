//
//  CameraPreviewReusableView.swift
//  Macroscop-TestAssignment
//
//  Created by Богдан Полыгалов on 04.11.2023.
//

import UIKit

final class CameraPreviewReusableView: UICollectionReusableView, ReusableHeaderIdentifying {
    // MARK: - fields

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.headline3
        return label
    }()

    // MARK: - override & required methods

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - internal methods

    func setTitle(text: String) {
        titleLabel.text = text
    }

    // MARK: - private methods

    private func setView() {
        backgroundColor = .clear
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
