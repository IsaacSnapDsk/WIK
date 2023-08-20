const mongoose = require("mongoose");
const { betSchema } = require("./bet");
import { Bet } from "./bet"

export interface Round {
    no: number
    kill: boolean
    turn: Turn
    half: boolean
    bets: Bet[]
}

export enum Turn {
    Betting = 'Betting',
    Waiting = 'Waiting',
    Results = 'Results',
    Final = 'Final'
}

const roundSchema = new mongoose.Schema({
    no: {
        required: true,
        type: Number,
        default: 1,
    },
    kill: {
        type: Boolean
    },
    turn: {
        required: true,
        type: String,
        default: 'Betting',
    },
    half: {
        required: true,
        type: Boolean,
        default: false
    },
    bets: [betSchema]
});

const roundModel = mongoose.model("Round", roundSchema);
module.exports = {
    roundModel: roundModel,
    roundSchema: roundSchema
};