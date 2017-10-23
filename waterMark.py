#encoding=utf-8

import cv2
import numpy as np
import scipy as sp
from scipy import linalg

# 以灰度图读取图像
img1 = cv2.imread("./data/nju.jpg", 0)
img2 = cv2.imread("./data/id.jpg", 0)

# 缩放尺寸至统一大小
img1 = cv2.resize(img1, (400, 400))
img2 = cv2.resize(img2, (400, 400))

cv2.imwrite("orignal.jpg", img1)

alphaList = [0.01, 0.2, 0.5, 1.0] # 水印强度

for alpha in alphaList:

    # 转化为浮点型数据参与运算
    img1 = img1.astype(np.float64)
    img2 = img2.astype(np.float64)

    # 加密过程
    U, s, V = linalg.svd(img1)
    s = linalg.diagsvd(s, 400, 400)
    L = s + alpha*img2

    U1, s1, V1 = linalg.svd(L)
    s1 = linalg.diagsvd(s1, 400, 400)
    imgW = np.dot(U, np.dot(s1, V))

    cv2.imwrite("WaterMark"+str(alpha)+".jpg", imgW)

    # 解码过程
    Up, sp, Vp = linalg.svd(imgW, full_matrices=False)
    sp = linalg.diagsvd(sp, 400, 400)
    imgF = np.dot(U1, np.dot(sp, V1))
    imgWaterMark = (imgF-s)/alpha
    imgWaterMark = cv2.normalize(imgWaterMark, 0, 255, norm_type=cv2.NORM_MINMAX).astype(np.uint8)

    cv2.imwrite("WaterMarkDecode" + str(alpha) + ".jpg", imgWaterMark)



