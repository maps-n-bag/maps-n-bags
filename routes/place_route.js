const express = require('express')
const router = express.Router()
const {getPLace,getActivity} = require('../controllers/place')

router.get('/', getPLace)
router.get('/activity/', getActivity)
module.exports = router