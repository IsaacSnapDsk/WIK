require('dotenv').config();

import { Player } from "./src/models/player";
import { Room } from "./src/models/room";
import { Turn } from "./src/models/round";
import { Vote } from "./src/models/vote";

// importing modules
const http = require("http");
const mongoose = require("mongoose");

// const app = express();
const host = process.env.HOST || "localhost";
const port = process.env.PORT || 3000;
const server = http.createServer();
const serverRoom = require("./src/models/room");
const serverPlayer = require("./src/models/player");
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

//  Sets the turn from Voting to Waiting
const stopVoting = async (room): Promise<Room> => {
    //  Grab our current round
    const round = room.rounds[room.currentRound]

    //  Grab the players from our current room
    const players = room.players.filter((x: Player) => x.vote)

    //  Store everyone's vote
    const votes = players.map((x: Player) => x.vote)

    //  Store the votes for the current round
    round.votes = votes

    //  Change the round's turn to "Voting"
    round.turn = Turn.Voting

    //  Update this round in our room
    room.rounds[room.currentRound] = round

    //  TODO Save our round
    room = await room.save()

    //  TODO update our round's turn in the DB
    //  TODO update our list of rounds in the DB

    return room
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
    socket.on("createRoom", async ({ roomName, nickname, maxRounds }) => {
        console.log(nickname);
        try {
            // Create a new room
            const room = new serverRoom({
                name: roomName,
                maxRounds: maxRounds,
                rounds: []
            });

            //  Create our player (also the GM)
            // const player = new serverPlayer({
            //     socketID: socket.id,
            //     name: nickname
            // })
            const player = {
                socketId: socket.id,
                name: nickname
            }

            //  Add our player to the room
            room.players.push(player);

            //  Create our first round
            // const round = {
            //     no: 1,
            //     votes: []
            // }

            // //  Set our first round in the room
            // room.rounds.push(round)

            //  Save our room
            const savedRoom = await room.save();
            console.log(savedRoom);

            //  Grab our room id
            const roomId = room._id.toString();

            //  Subscribe to this room's connection
            socket.join(roomId);
            // io -> send data to everyone
            // socket -> sending data to yourself
            io.to(roomId).emit("createRoomSuccess", savedRoom);
        } catch (e) {
            console.log(e);
        }
    });

    socket.on("joinRoom", async ({ roomId, name }) => {
        try {
            //  Find our room
            const room = await serverRoom.findById(roomId)

            //  If it isn't found, return an error
            if (!room) return socket.emit("errorOccurred", "Please enter a valid room ID.")

            //  Else, we found our room so lets create a player to connect to it
            // const player = new serverPlayer({
            //     socketId: socket.id,
            //     name: name
            // })

            const player = {
                socketId: socket.id,
                name: name
            }

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
            console.log('nahhaha')
        }
    });

    socket.on("postVote", async ({ roomId, vote }) => {
        try {
            //  Grab our current room
            const room = await serverRoom.findById(roomId)

            //  Find the player matching this vote id
            const player = await serverPlayer.findById(vote.playerId)

            //  Grab our current round
            const round = room.rounds[room.currentRound]

            //  Find the index of the vote for this player
            const idx = round.votes.findIndex((x: Vote) => x.playerId = player._id)

            //  If we found the index then update the vote
            if (idx !== -1) round.votes[idx] = vote
            else round.push(vote)

            //  Update our room
            room.rounds[room.currentRound] = round
            const savedRoom = room.save()

            //  Update the player's vote
            player.vote = vote

            //  Save our player
            const savedPlayer = await player.save()

            //  Inform client about vote
            io.to(roomId).emit("votePostSuccess", round)
        } catch (e) {
            console.log(`Error posting vote ${e}`)
        }
    })

    socket.on("stopVoting", async ({ roomId }) => {
        try {
            //  TODO add validation that prevents changing under following circumstances:

            //  Grab our current room
            const room = await serverRoom.findById(roomId)

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
            const room = await serverRoom.findById(roomId)

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
    //                 socketID: socket.id,
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