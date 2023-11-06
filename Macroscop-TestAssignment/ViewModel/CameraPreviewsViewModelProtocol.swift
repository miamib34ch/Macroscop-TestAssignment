//
//  CameraPreviewsViewModelProtocol.swift
//  Macroscop-TestAssignment
//
//  Created by Богдан Полыгалов on 06.11.2023.
//

import UIKit
import Alamofire

protocol CameraPreviewsViewModelProtocol {
    var onServerConfigResponseReceive: Binding<[CameraPreviewGroup]?>? { get set }
    var cameraPreviewGroups: [CameraPreviewGroup]? { get }
    
    func fetchServerConfig()
    func fetchPreviewImage(cameraId: String, completion: @escaping (Data) -> Void) -> DataRequest
    func takeErrorAlert(completion: @escaping () -> Void) -> UIAlertController
}
