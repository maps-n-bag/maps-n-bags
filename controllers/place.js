const asyncWrapper = require('../middleware/async')
const get_activity_info = require('../model/activity')
const get_place_info = require('../model/place')
const getPLace = asyncWrapper(async (req, res) => {
    const id = req.query.id
    console.log(`id: ${id}`)
    const place = await get_place_info(id)
    res.status(200).json({place})
});
const getActivity = asyncWrapper(async (req, res) => {
    const id = req.query.id
    console.log(`id: ${id}`)
    const activity = await get_activity_info(id)
    res.status(200).json({activity})
});
module.exports = {getPLace,getActivity}

