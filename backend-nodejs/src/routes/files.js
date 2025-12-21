const express = require('express');
const path = require('path');
const config = require('../config');
const FileHandler = require('../utils/fileHandler');
const PathHelper = require('../utils/pathHelper');

const router = express.Router();

// 列出输出文件
router.get('/output', (req, res) => {
  const files = FileHandler.listFiles(config.OUTPUT_DIR, ['.png', '.jpg', '.jpeg', '.webp', '.gif']);
  res.json({ success: true, data: files });
});

// 列出输入文件
router.get('/input', (req, res) => {
  const files = FileHandler.listFiles(config.INPUT_DIR, ['.png', '.jpg', '.jpeg', '.webp', '.gif']);
  res.json({ success: true, data: files });
});

// 保存图片到output目录
router.post('/save-output', (req, res) => {
  const { imageData, filename } = req.body;
  
  if (!imageData) {
    return res.status(400).json({ success: false, error: '缺少图片数据' });
  }
  
  const result = FileHandler.saveImage(imageData, config.OUTPUT_DIR, filename);
  res.json(result);
});

// 保存图片到input目录
router.post('/save-input', (req, res) => {
  const { imageData, filename } = req.body;
  
  if (!imageData) {
    return res.status(400).json({ success: false, error: '缺少图片数据' });
  }
  
  const result = FileHandler.saveImage(imageData, config.INPUT_DIR, filename);
  res.json(result);
});

// 保存图片到系统桌面
router.post('/save-desktop', (req, res) => {
  const { imageData, filename } = req.body;
  
  if (!imageData) {
    return res.status(400).json({ success: false, error: '缺少图片数据' });
  }
  
  const desktopPath = PathHelper.getDesktopPath();
  const result = FileHandler.saveImage(imageData, desktopPath, filename);
  
  if (result.success) {
    result.desktop_path = desktopPath;
  }
  
  res.json(result);
});

// 删除输出文件
router.delete('/output/:filename', (req, res) => {
  const filename = req.params.filename;
  const filePath = path.join(config.OUTPUT_DIR, filename);
  
  // 安全检查：确保文件在output目录内
  const safePath = PathHelper.safePath(config.OUTPUT_DIR, filename);
  if (!safePath) {
    return res.status(400).json({ success: false, error: '非法文件路径' });
  }
  
  const deleted = FileHandler.deleteFile(filePath);
  if (deleted) {
    res.json({ success: true, message: '文件已删除' });
  } else {
    res.status(404).json({ success: false, error: '文件不存在' });
  }
});

// 删除输入文件
router.delete('/input/:filename', (req, res) => {
  const filename = req.params.filename;
  const filePath = path.join(config.INPUT_DIR, filename);
  
  // 安全检查：确保文件在input目录内
  const safePath = PathHelper.safePath(config.INPUT_DIR, filename);
  if (!safePath) {
    return res.status(400).json({ success: false, error: '非法文件路径' });
  }
  
  const deleted = FileHandler.deleteFile(filePath);
  if (deleted) {
    res.json({ success: true, message: '文件已删除' });
  } else {
    res.status(404).json({ success: false, error: '文件不存在' });
  }
});

module.exports = router;
