/*
BlockChain Assignment 2
Truffle Testing File
By:
1.Awani Rawat       - 20172029
2.Swarnika Sharma   - 20172117
3.Aditya Singh Bisht- 20172121
4.Shubhika Jain     - 20172112
*/
var Contract = artifacts.require("Quiz");
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
    
    /*Reward should be as follows:
    * Player 1=5
    * Player 2=3
    * Player 3=4
    */
    
    const rew=[ [1,1,1],[2,2,1],[3,2,1],[4,2,1] ]
    for(let j = 0; j < 4; j++) {
        it("Check if answers are being recorded and eliminated players are not getting reward",async function(){
            var instance
            await Contract.deployed({from: n[0]}).then(function(instance_){
                instance = instance_
            });
            await instance.set_question(j+1,j+1,{from: n[0]}) 
            for(let i=0; i<3;i++){
                // console.log(i,j,ans[i][j])
                await instance.record_answer(j+1, ans[i][j],{from: n[i+1]})
            }
            await instance.check_answers({from: n[0]})
            for(let i=0; i<3;i++){
                var count1 = await instance.p_list.call(i)
                const temp = (count1[1].c)[0]
                // console.log(temp)
                assert.equal(temp,rew[j][i], 'Reward is wrong')
            }
           
        });
    }
    
});
