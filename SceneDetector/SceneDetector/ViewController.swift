//
//  ViewController.swift
//  SceneDetector
//
//  Created by Silence on 2018/11/18.
//  Copyright © 2018 Silence. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    // 控件引用
    @IBOutlet weak var scene: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    
    let vowels: [Character] = ["a", "e", "i", "o", "u"]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "train_night") else {
            fatalError("no starting image")
        }
        
        scene.image = image
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        
        detectScene(image: ciImage)
    }
}

// MARK: - 识别图片
extension ViewController {
    func detectScene(image: CIImage) {
        answerLabel.text = "detecting scene..."
        
        // 加载Core ML 模型
        guard let model = try? VNCoreMLModel(for: GoogLeNetPlacesInput().model) else {
            fatalError("can't load Places ML model")
        }
        
        // 创建一个代码完成回调的vision请求
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let result = request.results as? [VNClassificationObservation],
                let topResult = result.first else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            
            // 获取结果在主线程上更新UI
            let article = (self?.vowels.contains(topResult.identifier.first!))! ? "an" : "a"
            DispatchQueue.main.async {[weak self] in
                self?.answerLabel.text = "\(Int(topResult.confidence * 100))% it's \(article) \(topResult.identifier)"
            }
        }
        
        // 在异步线程上运行Core ML
        let handle = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handle.perform([request])
            }catch {
                print(error)
            }
        }
    }
}

// MARK: - Action
extension ViewController {
    @IBAction func pickImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .savedPhotosAlbum
        present(pickerController, animated: true)
    }
}

// MARK: - UINavigationControllerDelegate & UIImagePickerControllerDelegate
extension ViewController: UINavigationControllerDelegate & UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("couldn't load image from Photos")
        }
        
        scene.image = image
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        
        detectScene(image: ciImage)
    }
}

