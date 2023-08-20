import { Bet } from "./bet";

const mongoose = require("mongoose");

export interface Player {
    _id: string
    name: string
    wins: number
    drinks: number
    shots: number
    bbs: number
    bet: Bet
}

const playerSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    socketId: {
        type: String,
    },
    wins: {
        type: Number,
        default: 0,
    },
    drinks: {
        type: Number,
        default: 0,
    },
    shots: {
        type: Number,
        default: 0,
    },
    bb: {
        type: Number,
        default: 0,
    },
    bets: {
        type: Array,
        default: [],
    },
});

const playerModel = mongoose.model("Player", playerSchema);
module.exports = {
    playerModel: playerModel,
    playerSchema: playerSchema
};