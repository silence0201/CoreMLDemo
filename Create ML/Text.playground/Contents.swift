import CreateML

import Foundation

// 创建一个名为data的常量，它是垃圾邮件的一种MLDataTable。json文件。MLDataTable是一个全新的对象，用于创建一个决定训练或评估ML模型的表
let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/silence/Desktop/Share/Resource/spam.json"))
// 将数据分为trainingData和testingData,比率是80-20，种子是5 种子是指分类器的起点
let (trainingData, testingData) = data.randomSplit(by: 0.8, seed: 5)
// 训练数据定义一个叫做spamClassifier的MLTextClassifier，定义数据的值是文本，什么值是标签。
let spamClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "label")

// 创建了两个变量，名为trainingAccuracy和validationAccuracy，用于确定分类器的准确程度。在侧窗格中，您可以看到百分比。
let trainingAccuracy = (1.0 - spamClassifier.trainingMetrics.classificationError) * 100
let validationAccuracy = (1.0 - spamClassifier.validationMetrics.classificationError) * 100

// 检查评估的执行情况
let evaluationMetrics = spamClassifier.evaluation(on: testingData)
let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100

// 为ML模型创建一些元数据，如作者、描述和版本。我们使用write()函数将模型保存到我们选择的位置
let metadata = MLModelMetadata(author: "Silence", shortDescription: "A model trained to classify spam messages", version: "1.0")

try spamClassifier.write(to: URL(fileURLWithPath: "/Users/silence/Desktop/Share/Save/SpamDetector.mlmodel"), metadata: metadata)
