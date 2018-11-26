#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2018-11-23 00:21
# @Author  : Silence
# @Site    :
# @File    : Cover.py
# @Software: PyCharm

import coremltools

# Convert a caffe model to a classifier in Core ML
# ('bvlc_alexnet.caffemodel', 'deploy.prototxt') : 训练好的模型以及用于测试时使用的模型
coreml_model = coremltools.converters.caffe.convert(('bvlc_alexnet.caffemodel', 'deploy.prototxt'),
                                                    predicted_feature_name='class_labels.txt'
                                                   )


# Set model metadata
coreml_model.author = 'Silence'
coreml_model.license = 'BSD'
coreml_model.short_description = 'A Simple Example'

# Now save the model
coreml_model.save('BVLCObjectClassifier.mlmodel')