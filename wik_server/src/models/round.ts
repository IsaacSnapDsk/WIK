const mongoose = require("mongoose");
const voteSchema = require("./vote");
import { Vote } from "./vote"

export interface Round {
    no: number
    kill: boolean
    turn: Turn
    half: boolean
    votes: Vote[]
}

export enum Turn {
    Voting = 'Voting',
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
        default: 'Voting',
    },
    half: {
        required: true,
        type: Boolean,
        default: false
    },
    votes: [voteSchema]
});

const roundModel = mongoose.model("Round", roundSchema);
module.exports = roundModel;