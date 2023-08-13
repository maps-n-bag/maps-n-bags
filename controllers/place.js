const asyncWrapper = require('../middleware/async')
const get_place_info = require('../model/place')
const getPLace = asyncWrapper(async (req, res) => {
    const id = req.query.id
    console.log(`id: ${id}`)
    const place = await get_place_info(id)
    res.status(200).json({place})
})
module.exports = getPLace

