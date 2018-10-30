/*
BlockChain Assignment 2
By:
1.Awani Rawat       - 20172029
2.Swarnika Sharma   - 20172117
3.Aditya Singh Bisht- 20172121
4.Shubhika Jain     - 20172112
*/
pragma solidity ^0.4.24;
contract Quiz{
    /*
    *structure to store player information
    *-player's address
    *-player's earned reward
    *-player's fee to participate
    *-a flag thatdenotes if the player is still in the game or has been eliminated in a round
    */
    struct player{
        address addr_player;
        int32 reward;
        int32 fee;
        bool flag;
    }
    /*getter functions for the structure*/
    
    /*
    *each player's information is stored against his ID generated automatically by contract
    *This function fetches the ID corresponding to a particular player's address
    */
    function get_id(address addr) public returns(int32)
    {
        if(msg.sender==addr_host||msg.sender==addr)
        {
            for(int32 i=0;i<no_reg_players;i++)
            {
                if(addr==p_list[i].addr_player)
                    return i;
            }
        }
        return -1;
    }
    /*
    *getter function to fetch the reward of a player
    */
    function get_reward(int32 id) public returns(int32)
    {
        return p_list[id].reward;
    }
    /*
    *getter function to fetch if a player has been eliminated or not
    */
    function get_flag(int32 id) public returns(int32)
    {
        return p_list[id].fee;
    }
    
    /* Variable declarations*/
    int32 public no_of_ques;        //number of questions in quiz
    int32 public no_of_players;     //maximum number of players that can participate in quiz
    int32 public no_reg_players;    //total number of registered participants
    int32 public total_fee;         //total fee gained by contract
    int32 public aggr_fee;          //aggregated fee of all participants
    int32 public round;             //current round of Quiz
    int32 public reward;            //common reward for each correct answer 
    address public addr_host;       //address of the host of the quiz
    bool quizopen;
    mapping(int32 => player) public p_list;                         //structure to store player information against system generated ID
    mapping(int32 => int32) public q_answers;                       //correct option against each question
    mapping(int32 => mapping(int32 => int32)) public p_answers;     //stores question number => id of player => answer by player
    
    function get_count_players() public returns (int32)
    {
        return no_reg_players;
    }
    function Quiz(int32 max_players)
    {
        no_of_ques=4;
        round=0;
        no_of_players=max_players;
        addr_host=msg.sender;
        total_fee=0;
        quizopen=false;
    }
    
    function get_aggr_fee() public returns(int32)
    {
        return total_fee/no_reg_players;
    }
    
    function set_reward() public returns(int32)
    {
        return 3*aggr_fee;
    }
    
    function register_player(int32 f) public returns(int32)
    {
        address addr=msg.sender;
        if(no_reg_players < no_of_players&&addr!=addr_host)
        {
            if(get_id(addr)==-1)//player not registered earlier
            {
                p_list[no_reg_players].addr_player=addr;
                p_list[no_reg_players].reward=0;
                p_list[no_reg_players].fee=f;
                p_list[no_reg_players].flag = true;
                no_reg_players++;
                total_fee+=f;
                return 1;
            }
            return -1;
       }
       return -1;
    }
    
    function set_question(int32 r,int32 answer)
    {
        if(r==(round+1)&&msg.sender==addr_host)
        {
            q_answers[r] = answer;
            round++;
            quizopen=true;
        }
    }
    
    function get_answer(int32 q) public returns(int32)
    {
        return q_answers[q];
    }
    
    function record_answer(int32 q,int32 ans) 
    {
        if(round==q&&quizopen)
        {
           int32 id=get_id(msg.sender);
           if(id!=-1&&p_list[id].flag)
                p_answers[q][id] = ans;
        }
    }
    function check_answers()
    {
        aggr_fee=get_aggr_fee();
        reward=set_reward();
        if(msg.sender==addr_host&&round<=no_of_ques)
        {
            int32 ans=get_answer(round);
            for(int32 i=0;i<no_reg_players;i++)
            {
                if(p_list[i].flag&&ans==p_answers[round][i])
                {
                  //if player is not eliminated and answer given is correct
                    p_list[i].reward+=(reward/16);
                    total_fee-=(reward/16);
                }
                else//eliminate the player
                    p_list[i].flag=false;
            }
            quizopen=false;
        }
    }
}
