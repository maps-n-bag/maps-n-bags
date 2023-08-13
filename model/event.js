const client = require('../db/connect');

const get_event_model = async (Plan_id) => {
    const query = {
        text: 'SELECT * FROM public.event WHERE plan_id = $1 ORDER BY "order" ASC',
        values: [Plan_id]
    };
    const { rows } = await client.query(query);
    return rows;
};

const get_event_distance_model = async (plan_id) => {
    try {
        const q2 = {
            text: 'SELECT * FROM public.event WHERE plan_id = $1 ORDER BY "order" ASC',
            values: [plan_id]
        };
        const { rows: rows2 } = await client.query(q2);

        let length = rows2.length;
        let values = [];
        for (let i = 0; i < length - 1; i++) {
            query = {
                text: 'SELECT * FROM public.distance WHERE first_place_id = $1 and second_place_id = $2',
                values: [rows2[i].place_id, rows2[i + 1].place_id]
            };
            const result = await client.query(query);
            values.push(result.rows[0]);
        }
        return values;
    } catch (error) {
        console.error('Error:', error);
        return [];
    }
};

module.exports = { get_event_model, get_event_distance_model };
