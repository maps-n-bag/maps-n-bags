const client = require('../db/connect')
const getPlan = (async (id) => {
    const query = {
        text: 'SELECT * FROM public.plan WHERE id = $1',
        values: [id]
    }
    console.log(query)
    const {rows} = await client.query(query)
    console.log(rows)
    return rows[0]
})
module.exports = getPlan