const client = require('../db/connect');

const get_activity_info = async (id) => {
    try {
        const query = {
            text: 'SELECT * FROM public.activity WHERE id = $1',
            values: [id]
        };
        const { rows } = await client.query(query);
        return rows[0];
    } catch (error) {
        console.error('Error:', error);
        return null;
    }
};
module.exports = get_activity_info;