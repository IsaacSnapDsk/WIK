import { Player } from "./src/models/player";
import { Room } from "./src/models/room";
import { Round, Turn } from "./src/models/round";

// importing modules
const express = require("express");
const http = require("http");
const mongoose = require("mongoose");

const app = express();
const port = process.env.PORT || 3000;
const server = http.createServer(app);
const serverRoom = require("./models/room");
var io = require("socket.io")(server);

// middle ware
app.use(express.json());

const rounds: Round[] = []

const DB =
    "mongodb+srv://rivaan:test123@cluster0.rmhtu.mongodb.net/myFirstDatabase?retryWrites=true&w=majority";


//  TODO make typescript integrate with our mongo schemas


// const setCalculatingTurn = async (round: Round, room): Promise<Turn> => {
//     //  
// }

const stopVoting = async (room): Promise<Turn> => {
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

    return Turn.Voting
}

// const setNextTurn = (room: Room): Turn => {
//     //  Grab our current round
//     const round = room.rounds[room.currentRound]

//     //  Grab our round's current turn
//     const turn = round.turn

//     //  Based on this turn, we want to set the next turn
//     const nextTurn = {
//         Voting: () => setWaitingTurn(round, room),
//         Waiting: () => setCalculatingTurn(round, room)
//     }[turn]()

//     //  Return our turn
//     return nextTurn
// }


io.on("connection", (socket) => {
    console.log("connected!");
    // socket.on("createRoom", async ({ nickname }) => {
    //     console.log(nickname);
    //     try {
    //         // room is created
    //         let room = new Room();
    //         let player = {
    //             socketID: socket.id,
    //             nickname,
    //             playerType: "X",
    //         };
    //         room.players.push(player);
    //         room.turn = player;
    //         room = await room.save();
    //         console.log(room);
    //         const roomId = room._id.toString();

    //         socket.join(roomId);
    //         // io -> send data to everyone
    //         // socket -> sending data to yourself
    //         io.to(roomId).emit("createRoomSuccess", room);
    //     } catch (e) {
    //         console.log(e);
    //     }
    // });

    socket.on("stopVoting", async ({ roomId }) => {
        try {
            //  TODO add validation that prevents changing under following circumstances:

            //  Grab our current room
            const room = await serverRoom.findById(roomId)

            //  TODO make it so players cannot join in the middle

            //  Set our next turn
            const turn = stopVoting(room)

            //  Return our new turn
            io.to(roomId).emit("changeTurnSuccess", turn)
        }
        catch (e) {
            console.log(`Error changing turn ${e}`)
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

    // socket.on("winner", async ({ winnerSocketId, roomId }) => {
    //     try {
    //         let room = await Room.findById(roomId);
    //         let player = room.players.find(
    //             (playerr) => playerr.socketID == winnerSocketId
    //         );
    //         player.points += 1;
    //         room = await room.save();

    //         if (player.points >= room.maxRounds) {
    //             io.to(roomId).emit("endGame", player);
    //         } else {
    //             io.to(roomId).emit("pointIncrease", player);
    //         }
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
        console.log(e);
    });

server.listen(port, "0.0.0.0", () => {
    console.log(`Server started and running on port ${port}`);
});