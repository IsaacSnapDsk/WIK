require('dotenv').config();
const crypto = require('crypto')

import { Player } from "./src/models/player";
import { Room } from "./src/models/room";
import { Turn } from "./src/models/round";
import { Bet } from "./src/models/bet";

// importing modules
const http = require("http");
const mongoose = require("mongoose");

// const app = express();
const host = process.env.HOST || "localhost";
const port = process.env.PORT || 3000;
const server = http.createServer();
const { gameMasterModel } = require("./src/models/game_master")
const { roomModel } = require("./src/models/room");
const { roundModel } = require("./src/models/round");
const { playerModel } = require("./src/models/player");
var io = require("socket.io")(server);

// const rounds: Round[] = []

//  Grab our password from our env
const password = process.env.MONGO_PASSWORD

//  Grab our URL from our env
const url = process.env.MONGO_URL

//  Replace the <password> query with our actual password to get the real url
const DB = url.replace("<password>", password)

//  Sets the turn from Waiting to Calculating
const startCalculating = async (room): Promise<Object[]> => {
    //  Grab our current round
    const round = room.rounds[room.currentRound]

    //  Grab the players from the current room
    // const players = room.players.filter((x: Player) => x.vote)

    //  Grab our votes
    const votes = room.votes

    //  Create our array of results
    const results = []

    //  Iterate through each vote to compute results
    for (let i = 0; i < votes.length; i++) {
        //  Check if this player won
        const win = votes[i].kill == room.kill

        //  Grab the players current vote
        const result = {
            win: win,
            playerId: votes[i].playerId,
            wager: votes[i].wager,
            amount: votes[i].amount
        }

        //  Add this to our array of results
        results.push(result)
    }

    //  Return our results array
    return results
}

//  Sets the turn from Betting to Waiting
const stopVoting = async (room): Promise<Room> => {
    //  Grab our current round
    const round = room.rounds[room.currentRound]

    //  Grab the players from our current room
    const players = room.players.filter((x: Player) => x.bet)

    //  Store everyone's vote
    const votes = players.map((x: Player) => x.bet)

    //  Store the votes for the current round
    round.votes = votes

    //  Change the round's turn to "Betting"
    round.turn = Turn.Betting

    //  Update this round in our room
    room.rounds[room.currentRound] = round

    //  TODO Save our round
    room = await room.save()

    //  TODO update our round's turn in the DB
    //  TODO update our list of rounds in the DB

    return room
}

const generateSecret = (): String => {
    return crypto.randomBytes(64).toString('hex');
}


/// SOCKET CONNECTION
io.on("connection", (socket) => {
    /// Test listener
    /// This will listen to "test" events from our client and then
    /// send a "testSuccess" event to ALL clients connected
    socket.on("test", async ({ message }) => {
        console.log('server test success: ', message)
        /// Test event
        /// This sends a "testSuccess" event to all clients
        socket.emit("testSuccess", "hello from server")
    })

    console.log("connected!");
    socket.on("createRoom", async ({ roomName, maxRounds }) => {
        try {
            // Create a new room
            const room = new roomModel({
                name: roomName,
                maxRounds: maxRounds,
                currentRound: 0,
                half: false,
                rounds: []
            });

            //  Grab our room id
            const roomId = room._id.toString();

            //  Create our game master
            const gameMaster = new gameMasterModel({
                socketId: socket.id,
                roomId: roomId,
                secret: generateSecret()
            })

            //  Save our game master
            await gameMaster.save()

            //  Add our game master to the room
            room.gameMaster = gameMaster

            //  Create our first round
            const round = new roundModel({
                no: 1,
                turn: 'Betting',
                votes: []
            })

            //  Set our first round in the room
            room.rounds.push(round)

            //  Save our room
            const savedRoom = await room.save();

            //  Subscribe to this room's connection
            socket.join(roomId);
            // io -> send data to everyone
            // socket -> sending data to yourself
            io.to(roomId).emit("createRoomSuccess", savedRoom);
            socket.emit('gameMasterCreatedSuccess', gameMaster)
        } catch (e) {
            console.log(e);
        }
    });

    socket.on("joinRoom", async ({ roomId, nickname }) => {
        try {
            //  Find our room
            const room = await roomModel.findById(roomId)

            //  If it isn't found, return an error
            if (!room) return socket.emit("errorOccurred", "Please enter a valid room ID.")

            //  Else, we found our room so lets create a player to connect to it
            const player = new playerModel({
                socketId: socket.id,
                name: nickname
            })

            //  Add our player to the room
            room.players.push(player)

            //  Save our room
            const savedRoom = await room.save()
            console.log('saved room', savedRoom)

            //  Subscribe to this room's connection
            socket.join(roomId)

            //  Notify about joining
            io.to(roomId).emit("joinRoomSuccess", savedRoom)
        } catch (e) {
            console.log('nahhaha', e)
        }
    });

    socket.on("startGame", async ({ roomId, gmId }) => {
        try {
            console.log('starting game', roomId, gmId)
            //  Grab our current room
            const room = await roomModel.findById(roomId)
            console.log('room', room)

            //  If it isn't found, return an error
            if (!room) return socket.emit("errorOccurred", "Room not found.")

            //  Find our game master with this secret
            const gameMaster = await gameMasterModel.findById(gmId)
            console.log('game master', gameMaster)

            //  If it isn't found, return an error
            if (!gameMaster) return socket.emit("errorOccurred", "Game Master not found")

            //  Check if this game master belongs to this room
            const belongs = gameMaster.roomId === roomId
            console.log('belongs', belongs)

            //  If they dont, return an error
            if (!belongs) return socket.emit("errorOccurred", "Game Master and Room do not match")

            //  Else, set the room to be started
            room.started = true

            //  Save our changes
            const savedRoom = await room.save()

            //  Notify client
            io.to(roomId).emit("startGameSuccess", savedRoom)
        }
        catch (e) {
            console.log("error bitch", e)
        }
    })

    socket.on("bet", async ({ roomId, bet }) => {
        try {
            //  Grab our current room
            const room = await roomModel.findById(roomId)

            //  If it isn't found, return an error
            if (!room) return socket.emit("errorOccurred", "Room not found.")

            //  Find the player matching this bet id
            const player = await playerModel.findById(bet.playerId)

            //  If it isn't found, return an error
            if (!player) return socket.emit("errorOccurred", "Player does not exist.")

            //  Grab our current round
            const round = room.rounds[room.currentRound]

            //  Update the player's bets
            player.bets.push(bet)

            //  Adds the player's bet to the round
            round.bets.push(bet)

            //  Find the index of the vote for this player
            const playerIdx = room.players.findIndex((x: Player) => x._id === player._id)

            //  Update our room
            room.rounds[room.currentRound] = round
            room.players[playerIdx] = player
            const savedRoom = await room.save()

            // Save our round
            round.save()

            //  Save our player
            player.save()

            //  Inform client about bet
            io.to(roomId).emit("betSuccess", savedRoom)
        } catch (e) {
            console.log(`Error posting bet ${e}`)
        }
    })

    socket.on("stopVoting", async ({ roomId }) => {
        try {
            //  TODO add validation that prevents changing under following circumstances:

            //  Grab our current room
            const room = await roomModel.findById(roomId)

            //  TODO make it so players cannot join in the middle

            //  Set our next turn
            const savedRoom = await stopVoting(room)


            //  Grab the current round
            const currentRound = savedRoom.rounds[savedRoom.currentRound]

            //  Return our new turn
            io.to(roomId).emit("changeTurnSuccess", currentRound)
        }
        catch (e) {
            console.log(`Error stopping voting ${e}`)
        }
    })

    socket.on("startCalculating", async ({ roomId, kill }) => {
        try {
            //  Grab our current room
            const room = await roomModel.findById(roomId)

            //  Set the current round's result
            room.kill = kill

            //  Start calculating
            const results = await startCalculating(room)

            //  Save our round
            room.rounds[room.currentRound].turn = Turn.Results
            const savedRoom = await room.save()

            //  Notify results
            results.forEach(x => io.to(roomId).emit('resultCalculated', x))

            //  Grab the current round
            const currentRound = savedRoom.rounds[savedRoom.currentRound]

            //  Return our new turn
            io.to(roomId).emit("changeTurnSuccess", currentRound)
        }
        catch (e) {
            console.log(`Error starting calculating ${e}`)
        }
    })

    // socket.on("joinRoom", async ({ nickname, roomId }) => {
    //     try {
    //         if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
    //             socket.emit("errorOccurred", "Please enter a valid room ID.");
    //             return;
    //         }
    //         let room = await Room.findById(roomId);

    //         if (room.isJoin) {
    //             let player = {
    //                 nickname,
    //                 socketId: socket.id,
    //                 playerType: "O",
    //             };
    //             socket.join(roomId);
    //             room.players.push(player);
    //             room.isJoin = false;
    //             room = await room.save();
    //             io.to(roomId).emit("joinRoomSuccess", room);
    //             io.to(roomId).emit("updatePlayers", room.players);
    //             io.to(roomId).emit("updateRoom", room);
    //         } else {
    //             socket.emit(
    //                 "errorOccurred",
    //                 "The game is in progress, try again later."
    //             );
    //         }
    //     } catch (e) {
    //         console.log(e);
    //     }
    // });

    // socket.on("tap", async ({ index, roomId }) => {
    //     try {
    //         let room = await Room.findById(roomId);

    //         let choice = room.turn.playerType; // x or o
    //         if (room.turnIndex == 0) {
    //             room.turn = room.players[1];
    //             room.turnIndex = 1;
    //         } else {
    //             room.turn = room.players[0];
    //             room.turnIndex = 0;
    //         }
    //         room = await room.save();
    //         io.to(roomId).emit("tapped", {
    //             index,
    //             choice,
    //             room,
    //         });
    //     } catch (e) {
    //         console.log(e);
    //     }
    // });
});

mongoose
    .connect(DB)
    .then(() => {
        console.log("Connection successful!");
    })
    .catch((e) => {
        console.log('mongoose error', e);
    });

server.listen(port, host, () => {
    console.log(`Server started and running on port ${port}`);
});