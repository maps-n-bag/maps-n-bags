const express = require('express')
const router = express.Router()
const getPLace = require('../controllers/place')

router.get('/', getPLace)
module.exports = router