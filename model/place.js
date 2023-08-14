const client = require('../db/connect');

const get_place_info = async (place_id) => {
    try {
        const query = {
            text: 'SELECT * FROM public.place WHERE id = $1',
            values: [place_id]
        };
        const { rows } = await client.query(query);

        const query2 = {
            text: 'SELECT image FROM public.place_image WHERE place_id = $1',
            values: [place_id]
        };
        const result2 = await client.query(query2);
        const images = result2.rows.map(row => row.image);

        console.log(images);
        
        return {
            data: {
                ...rows[0],
                images: images
            }
        };
    } catch (error) {
        console.error('Error:', error);
        return null;
    }
};


module.exports = get_place_info;
