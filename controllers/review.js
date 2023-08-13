const getReview= require('../model/review');
const getReviewController = async (req, res) => {
    const place_id=req.query.place_id;
    const review = await getReview(place_id);
    res.json(review);
};

module.exports = getReviewController;