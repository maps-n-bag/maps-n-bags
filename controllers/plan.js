const asyncWrapper = require('../middleware/async')
const get_plan_model = require('../model/plan')

const getPlan = asyncWrapper(async (req, res) => {
    const id = req.query.id
    console.log(`id: ${id}`)
    const plan = await get_plan_model(id)
    console.log(plan)
    res.status(200).json({plan})
})
module.exports = getPlan

