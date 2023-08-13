const express = require('express')
const router = express.Router()
const {get_event,get_event_distance} = require('../controllers/event')

router.get('/', get_event)
router.get('/distance/', get_event_distance)
module.exports = router