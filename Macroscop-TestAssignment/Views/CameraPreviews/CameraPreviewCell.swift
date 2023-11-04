//
//  CameraPreviewCell.swift
//  Macroscop-TestAssignment
//
//  Created by Богдан Полыгалов on 04.11.2023.
//

import UIKit
import Alamofire

final class CameraPreviewCell: UICollectionViewCell, ReuseIdentifying {
    // MARK: - fields

    /// Переменная, в которой запоминаем, есть ли запрос на картинку у клеточки. Нужна, поскольку нужно отменить запрос при переиспользовании. Если не отменить запрос при переиспользовании, то у ячейки может быть неправильная картинка, поскольку загрузка асинхронная.
    var task: DataRequest?

    private let placeholder = UIImage(named: "placeholder")
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyRegular
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - override & required methods

    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        task = nil
        imageView.image = placeholder
        nameLabel.text = ""
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        imageView.image = placeholder
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - internal methods

    func setImage(image: UIImage?) {
        guard let image = image else { return }
        imageView.image = image
    }

    func setNameLabel(name: String) {
        nameLabel.text = name
    }

    // MARK: - private methods

    private func setView() {
        backgroundColor = .clear
        addSubview(imageView)
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: frame.height*0.85),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
