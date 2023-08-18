import { Player } from "./player";
import { Round } from "./round";

const mongoose = require("mongoose");
const playerSchema = require("./player");
const roundSchema = require("./round");

export interface Room {
    maxRounds: number
    currentRound: number
    half: boolean
    players: Player[]
    rounds: Round[]
}

const roomSchema = new mongoose.Schema({
    name: {
        type: String,
        default: null
    },
    maxRounds: {
        type: Number,
        default: 6,
    },
    currentRound: {
        required: true,
        type: Number,
        default: 0,
    },
    half: {
        required: true,
        type: Number,
        default: 1
    },
    players: [playerSchema],
    // rounds: [roundSchema],
});

const roomModel = mongoose.model("Room", roomSchema);
module.exports = roomModel;