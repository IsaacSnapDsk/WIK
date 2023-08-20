import { Vote } from "./bet";

const mongoose = require("mongoose");

export interface GameMaster {
    name: string
    wins: number
    drinks: number
    shots: number
    bbs: number
    vote?: Vote
}

const gameMasterSchema = new mongoose.Schema({
    roomId: {
        type: String,
        required: true,
    },
    socketId: {
        type: String,
        required: true,
    },
    secret: {
        type: String,
        required: true,
    },
});

const gameMasterModel = mongoose.model("Game_Master", gameMasterSchema);
module.exports = {
    gameMasterModel: gameMasterModel,
    gameMasterSchema: gameMasterSchema
};