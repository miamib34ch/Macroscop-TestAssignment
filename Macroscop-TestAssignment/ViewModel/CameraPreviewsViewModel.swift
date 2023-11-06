//
//  CamerasPreviewViewModel.swift
//  Macroscop-TestAssignment
//
//  Created by Богдан Полыгалов on 03.11.2023.
//

import UIKit
import Alamofire

typealias Binding<T> = (T) -> Void

final class CameraPreviewsViewModel: CameraPreviewsViewModelProtocol {
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

    /// Метод для загрузки MJPEG потока с камеры
    func fetchPreviewImage(cameraId: String, completion: @escaping (Data) -> Void) -> DataStreamRequest {
        AF.streamRequest(Constants.serverRoot + Constants.serverMobileEndpoint, parameters: ["channelid": "\(cameraId)", "oneframeonly": "false", "login": "root", "withcontenttype": "true"]).validate().responseStream { stream in
            switch stream.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("Ошибка в CamerasPreviewViewModel_fetchPreviewImage: \(error.localizedDescription)")
            default:
                break
            }
        }
    }

    /// Метод, который возвращает алерт с сообщением о сетевой ошибке и кнопкой повторить
    func takeErrorAlert(completion: @escaping () -> Void) -> UIAlertController {
        let alertTitle = NSLocalizedString("alert.title", comment: "Название алерта")
        let alertMessage = NSLocalizedString("alert.message", comment: "Сообщение в алерте")
        let alertActionTitle = NSLocalizedString("alert.action.again", comment: "Название действия повторения в алерте")
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertActionTitle, style: .default) { [weak self] _ in
            self?.fetchServerConfig()
            completion()
        })
        return alert
    }

    /// Метод, который возвращает обновлённые данные кадра. Нужен поскольку нам приходит непрерывный поток данных, из которого мы собираем каждый кадр.
    func updateFrameCompleteness(of currentFrameData: Data?, with responseData: Data, completion: (UIImage) -> Void) -> Data {
        var frameData = currentFrameData ?? Data()

        // Добавляем новые данные кадра к уже имеющимся
        frameData.append(responseData)

        // Если оба (SoI и EoI) маркера MJPEG есть в последовательности данных
        if let soiRange = frameData.range(of: Constants.startOfImageMarker),
           let eoiRange = frameData.range(of: Constants.endOfImageMarker) {
            // Извлекаем данные текущего кадра
            let currentFrameData = frameData[soiRange.lowerBound..<eoiRange.upperBound]

            // Декодируем данные текущего кадра в изображение
            if let image = UIImage(data: currentFrameData) {
                // Обрабатываем полученное изображение
                completion(image)
            }

            // Удаляем обработанные данные текущего кадра
            frameData.removeSubrange(frameData.startIndex..<eoiRange.upperBound)
        }

        // Обновляем данные текущего кадра после обработки
        return frameData
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
