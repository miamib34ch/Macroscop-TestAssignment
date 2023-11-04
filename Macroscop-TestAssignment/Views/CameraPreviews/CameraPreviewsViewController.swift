//
//  CameraPreviewsViewController.swift
//  Macroscop-TestAssignment
//
//  Created by Богдан Полыгалов on 03.11.2023.
//

import UIKit

final class CameraPreviewsViewController: UIViewController {
    // MARK: - fields

    private let viewModel = CameraPreviewsViewModel()

    private let cameraPreviewsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let cameraPreviewsCollectionViewRefreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - override & required methods

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureCollection()
        configureRefreshControl()
        configureActivityIndicator()

        showActivityIndicator()
        bind()
    }

    // MARK: - private methods

    private func configureCollection() {
        cameraPreviewsCollectionView.backgroundColor = .clear
        cameraPreviewsCollectionView.refreshControl = cameraPreviewsCollectionViewRefreshControl

        cameraPreviewsCollectionView.dataSource = self
        cameraPreviewsCollectionView.delegate = self

        cameraPreviewsCollectionView.register(CameraPreviewCell.self)
        cameraPreviewsCollectionView.registerHeader(CameraPreviewReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)

        cameraPreviewsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraPreviewsCollectionView)
        NSLayoutConstraint.activate([
            cameraPreviewsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraPreviewsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraPreviewsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraPreviewsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureRefreshControl() {
        cameraPreviewsCollectionViewRefreshControl.tintColor = .label
        cameraPreviewsCollectionViewRefreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }

    private func configureActivityIndicator() {
        activityIndicator.color = .label
        activityIndicator.center = view.center
    }

    private func showActivityIndicator() {
        view.addSubview(activityIndicator)
        UIApplication.shared.windows.first?.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }

    private func removeActivityIndicator() {
        activityIndicator.stopAnimating()
        UIApplication.shared.windows.first?.isUserInteractionEnabled = true
    }

    /// Метод, где связываем события ViewModel с View
    private func bind() {
        viewModel.onServerConfigResponseReceive = { [weak self] response in
            guard let self = self else { return }
            self.removeActivityIndicator()
            switch response {
            case .some:
                self.cameraPreviewsCollectionView.reloadData()
            case .none:
                self.present(self.viewModel.takeErrorAlert(completion: showActivityIndicator), animated: true)
            }
        }
        viewModel.fetchServerConfig()
    }

    // MARK: - objc methods

    @objc private func pullToRefresh() {
        cameraPreviewsCollectionViewRefreshControl.endRefreshing()
        viewModel.fetchServerConfig()
    }
}

// MARK: - extension CameraPreviewsViewController + UICollectionViewDelegateFlowLayout

extension CameraPreviewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        6
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: 42)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32
        let height = width * 0.7
        return CGSize(width: width, height: height)
    }
}

// MARK: - extension CameraPreviewsViewController + UICollectionViewDataSource

extension CameraPreviewsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.cameraPreviewGroups?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cameraPreviewGroups?[section].cameraPreviews.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let cameraPreviewGroup = viewModel.cameraPreviewGroups?[indexPath.section] else { return UICollectionReusableView() }
            let headerView: CameraPreviewReusableView = cameraPreviewsCollectionView.dequeueReusableHeader(ofKind: kind, indexPath: indexPath)
            headerView.setTitle(text: cameraPreviewGroup.groupName)
            return headerView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cameraPreview = viewModel.cameraPreviewGroups?[indexPath.section].cameraPreviews[indexPath.row] else { return UICollectionViewCell() }
        let cell: CameraPreviewCell = cameraPreviewsCollectionView.dequeueReusableCell(indexPath: indexPath)
        cell.task = viewModel.fetchPreviewImage(cameraId: cameraPreview.cameraId) { data in
            cell.setImage(image: UIImage(data: data))
        }
        cell.setNameLabel(name: cameraPreview.cameraName)
        return cell
    }
}
