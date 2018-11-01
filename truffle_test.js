var Contract = artifacts.require("Quiz");
// import {PRIME_NUMBER_Q, NUMBER_OF_ITEMS, TRANSACTION_CONSTANT, BIDDER_JSON} from './constants';
// constants = require('./constants');
var assert = require('assert')
// var account_count = 1;
// var participation_fees = 10;90
var max_players=100

contract('Quiz',function(accounts){
    console.log("Quiz Started")
    var n = new Array()
    for(i = 0; i < max_players; i++) {
        n[i] = accounts[i];
    }
    for(j = 0; j < 3; j++) {
        const x = j;
        it("Check if player is getting registered",async function(){
            var instance
            await Contract.deployed({from: n[0]}).then(function(instance_){
                instance = instance_    
            });
            var count1
            var count2
            // await instance.get_count_players().then((result)=>{console.log(result)});
            await instance.no_reg_players().then(output=>{count1 = output})
            // await setTimeout(()=>console.log("HEllos"),2000)
            await instance.register_player(10, {from: accounts[x+1]})
            await instance.no_reg_players().then((result)=>{count2 = result});
            // console.log("Registered",count1.c[0],count2.c[0])
            assert.equal(count2.c[0], count1.c[0]+1, 'Player is unregistered')
        });
    }
    const ans=[ [1,2,3,4],[1,2,5,4],[1,6,3,4] ]
    // Reward for 1st shd be 5 , 2nd is 3, and 3rd 4th
    const rew=[ [1,1,1],[2,2,1],[3,2,1],[4,2,1] ]
    
     
});
