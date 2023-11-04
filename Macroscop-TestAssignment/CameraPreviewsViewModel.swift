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
    // MARK: - fields

    /// Событие, происходящие при окончании загрузки конфигурации сервера
    var onServerConfigResponseReceive: Binding<[CameraPreviewGroup]?>?
    /// Превью камер, собранные по группам
    private(set) var cameraPreviewGroups: [CameraPreviewGroup]?

    /// Переменная, которая хранит запрос на получение конфигурации сервера
    private var serverConfigRequest: DataRequest?

    // MARK: - internal methods

    /// Метод для загрузки конфигурации сервера
    func fetchServerConfig() {
        if serverConfigRequest != nil { return } // Если запрос уже выполняется, то ждём окончания
        serverConfigRequest = AF.request(Constants.serverRoot + Constants.serverConfigEndpoint, parameters: ["login": "root", "responsetype": "json"]).validate().responseDecodable(of: ServerConfig.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let serverConfig):
                self.cameraPreviewGroups = self.createCameraPreviewGroups(serverConfig: serverConfig)
                self.onServerConfigResponseReceive?(cameraPreviewGroups)
            case .failure(let error):
                print("Ошибка в CamerasPreviewViewModel_fetchServerConfig: \(error.localizedDescription)")
                self.onServerConfigResponseReceive?(nil)
            }
            self.serverConfigRequest = nil
        }
    }

    /// Метод для загрузки картинки камеры
    func fetchPreviewImage(cameraId: String, completion: @escaping (Data) -> Void) -> DataRequest {
        AF.request(Constants.serverRoot + Constants.serverMobileEndpoint, parameters: ["channelid": "\(cameraId)", "oneframeonly": "true", "login": "root", "withcontenttype": "true"]).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                if !error.isExplicitlyCancelledError {
                    print("Ошибка в CamerasPreviewViewModel_fetchPreviewImage: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - private methods

    /// Метод для создание групп, каждая со своими превью камер
    private func createCameraPreviewGroups(serverConfig: ServerConfig) -> [CameraPreviewGroup] {
        let cameraPreviewGroups: [CameraPreviewGroup] = serverConfig.rootSECObject.childSECObjects.map { group in
            let cameraPreviews: [CameraPreview] = serverConfig.channels
                .filter { channel in group.childChannels.contains(channel.id) }
                .map { channel in
                    return CameraPreview(cameraId: channel.id, cameraName: channel.name)
                }
            return CameraPreviewGroup(groupName: group.name, cameraPreviews: cameraPreviews)
        }
        return cameraPreviewGroups
    }
}
