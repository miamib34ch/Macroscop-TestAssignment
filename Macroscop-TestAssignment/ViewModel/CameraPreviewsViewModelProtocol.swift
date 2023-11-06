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
    func fetchPreviewImage(cameraId: String, completion: @escaping (Data) -> Void) -> DataStreamRequest
    func takeErrorAlert(completion: @escaping () -> Void) -> UIAlertController
    func updateFrameCompleteness(of currentFrameData: Data?, with responseData: Data, completion: (UIImage) -> Void) -> Data
}
