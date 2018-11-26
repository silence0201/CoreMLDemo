#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2018-11-23 00:21
# @Author  : Silence
# @Site    :
# @File    : Use.py
# @Software: PyCharm

import coremltools

# 加载模型
model =  coremltools.models.MLModel('HousePricer.mlmodel')

# 做预测
predictions = model.predict({'RM': 5, 'LSTAT': 5, 'PTRATIO': 5})

# 获取结果
print("房屋价格:%.2f" % predictions['MEDV'])