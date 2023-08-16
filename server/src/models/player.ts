import { Vote } from "./vote";

const mongoose = require("mongoose");

export interface Player {
    name: string
    wins: number
    drinks: number
    shots: number
    bbs: number
    vote?: Vote
}

const playerSchema = new mongoose.Schema({
    name: {
        type: String,
        trim: true,
    },
    socketID: {
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
    shotes: {
        type: Number,
        default: 0,
    },
    bb: {
        type: Number,
        default: 0,
    },
    vote: {
        type: Object,
        default: null,
    },
});

module.exports = playerSchema;