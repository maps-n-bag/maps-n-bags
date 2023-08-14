const express = require('express')
const router = express.Router()
const {get_event,get_event_distance,get_event_detail} = require('../controllers/event')

router.get('/', get_event)
router.get('/distance/', get_event_distance)
router.get('/detail/', get_event_detail)
module.exports = router