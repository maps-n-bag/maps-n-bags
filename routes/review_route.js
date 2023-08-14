const getReviewController= require('../controllers/review');
const express = require('express');
const router = express.Router();

router.get('/', getReviewController);

module.exports = router;
