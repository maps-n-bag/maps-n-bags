const pg=require('pg');
const client=new pg.Client({connectionString:process.env.URL});

async function connect(){
    try{
        await client.connect();
        console.log('connected to db');
    }catch(e){
        console.error(`Failed to connect ${e}`);
    }
}
connect();
module.exports = client;