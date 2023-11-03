//
//  CamerasPreviewViewModel.swift
//  Macroscop-TestAssignment
//
//  Created by Богдан Полыгалов on 03.11.2023.
//

import Foundation
import Alamofire

typealias Binding<T> = (T) -> Void

final class CameraPreviewsViewModel {
    var onResponseReceive: Binding<[CameraPreview]?>?

    func fetchServerConfig() {
        AF.request(Constants.serverRoot + Constants.serverConfigEndpoint, parameters: ["login": "root", "responsetype": "json"]).validate().responseDecodable(of: ServerConfig.self) { [weak self] response in
            switch response.result {
            case .success(let serverConfig):
                let cameraPreviews = self?.createCameraPreviews(serverConfig: serverConfig)
                self?.onResponseReceive?(cameraPreviews)
            case .failure(let error):
                print("CamerasPreviewViewModel_fetchData_error: \(error.localizedDescription)")
                self?.onResponseReceive?(nil)
            }
        }
    }

    private func createCameraPreviews(serverConfig: ServerConfig) -> [CameraPreview] {
        var cameraPreviews: [CameraPreview] = []
        for chanel in serverConfig.channels {
            for section in serverConfig.rootSECObject.childSECObjects where section.childChannels.contains(chanel.id) {
                cameraPreviews.append(CameraPreview(cameraId: chanel.id, cameraName: chanel.name, cameraGroup: section.name))
                break
            }
        }
        return cameraPreviews
    }
}
