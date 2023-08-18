const mongoose = require('mongoose')

export interface Vote {
    playerId: number
    kill: boolean
    wager: Wager
    amount: number
}

export enum Wager {
    Drink,
    Shot,
    BB
}

const betSchema = new mongoose.Schema({
    wager: {
        required: true,
        type: String,
        default: 'Shot',
    },
    amount: {
        required: true,
        type: Number,
        default: 1
    }
});

const voteSchema = new mongoose.Schema({
    playerId: {
        required: true,
        type: Number,
    },
    kill: {
        required: true,
        type: Boolean,
        default: true,
    },
    bet: {
        required: true,
        type: Object
    }
});

const voteModel = mongoose.model("Vote", voteSchema);
module.exports = voteModel;