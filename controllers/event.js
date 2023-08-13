const asyncWrapper = require('../middleware/async')
const {get_event_model,get_event_distance_model} = require('../model/event')


const get_event = asyncWrapper(async (req, res) => {
    const plan_id = req.query.plan_id
    const plan = await get_event_model(plan_id)
    console.log(plan)
    res.status(200).json({plan})
})
const get_event_distance = asyncWrapper(async (req, res) => {
    const plan_id = req.query.plan_id
    const distance = await get_event_distance_model(plan_id)
    res.status(200).json({distance})
})
module.exports ={get_event,get_event_distance}