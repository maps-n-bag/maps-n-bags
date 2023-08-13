const express = require("express")
const app = express()
const env=require('dotenv').config();
const plan = require("./routes/plan_route")
const event = require("./routes/event_route")
const cors = require("cors")
const place = require("./routes/place_route")
const review = require("./routes/review_route")


app.use(express.json())
app.use(cors())
app.use("/plan", plan)
app.use("/event", event)
app.use("/place", place)
app.use("/review", review)

const port = process.env.PORT || 3000
app.listen(port, console.log(`Server started on port ${port}`))