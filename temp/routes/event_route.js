const express = require('express')
const router = express.Router()
const getPlan = require('../controllers/event')

router.get('/', getPlan)
module.exports = router