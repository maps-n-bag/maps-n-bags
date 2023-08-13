const express = require("express")
const app = express()
const env=require('dotenv').config();
const plan = require("./routes/plan_route")


app.use(express.json())
app.use("/plan", plan)

const port = process.env.PORT || 3000
app.listen(port, console.log(`Server started on port ${port}`))