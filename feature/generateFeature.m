function generateFeature(imPath, outPath, param)


[feat.data, feat.x, feat.y] = param.funFeat(imPath);




save(outPath, 'feat');

