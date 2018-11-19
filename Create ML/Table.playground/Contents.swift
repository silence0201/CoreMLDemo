import CreateML

import Foundation

// csv中引用我们的数据。这是通过简单的URL调用完成的
//    表中数据含义:
//    RM:  每个住宅的平均房间数
//    LSTAT: 人口中被认为地位较低的百分比
//    PTRATIO: 城镇学生与学生的比率
//    MEDV: 自住房屋的中位数
let houseData = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/silence/Desktop/Share/Resource/HouseData.csv"))
// 定义应该将数据的哪些部分分解为训练和测试。我们像往常一样把它分成80-20个，为了稍微改变一下，让我们从头开始(将种子设置为0)。
let (trainingCSVData, testCSVData) = houseData.randomSplit(by: 0.8, seed: 0)

// 选择训练数据为室内数据，将目标列设为MEDV，即中位价格。
let pricer = try MLRegressor(trainingData: houseData, targetColumn: "MEDV")

// 定义模型的元数据并保存
let csvMetadata = MLModelMetadata(author: "Silence", shortDescription: "A model used to determine the price of a house based on some features.", version: "1.0")
try pricer.write(to: URL(fileURLWithPath: "/Users/silence/Desktop/Share/Save/HousePricer.mlmodel"), metadata: csvMetadata)


