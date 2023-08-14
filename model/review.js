const client = require('../db/connect');

const getReview = async (place_id) => {
    const query = {
        text: 'SELECT * FROM review WHERE place_id = $1',
        values: [place_id]
    };
    const { rows } = await client.query(query);
    let length = rows.length;
    let reviews = [];
    for (let i = 0; i < length; i++) {
        const query2 = {
            text: 'SELECT image FROM review_image WHERE review_id = $1',
            values: [rows[i].id]
        };
        const { rows: imageRows } = await client.query(query2);

        const imagesWithoutId = imageRows.map((imageRow) => {
            const { id, ...rest } = imageRow;
            return rest;
        });

        reviews.push({
            ...rows[i], 
            review_image: imagesWithoutId 
        });
    }
    return reviews;
};

module.exports = getReview;
