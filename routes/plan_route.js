const express = require('express')
const router = express.Router()
const getPlan = require('../controllers/plan')

router.get('/', getPlan)
module.exports = router