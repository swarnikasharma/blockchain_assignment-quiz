pragma solidity ^0.4.24;
contract Quiz{
    struct player{
        address addr_player;
        int32 reward;
        int32 fee;
        bool flag;
    }
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
    function get_reward(int32 id) public returns(int32)
    {
        return p_list[id].reward;
    }
    function get_flag(int32 id) public returns(int32)
    {
        return p_list[id].fee;
    }
    
    int32 no_of_ques;
    int32 no_of_players;
    int32 no_reg_players;
    int32 total_fee;
    int32 aggr_fee;
    int32 round;
    address addr_host;
    
    mapping(int32 => player) p_list;
    mapping(int32 => int32) q_answers;
    mapping(int32 => mapping(int32 => int32)) p_answers;
    
    function Quiz(int32 p)
    {
        no_of_ques=4;
        round=1;
        no_of_players=p;
        addr_host=msg.sender;
    }
    function register_player(int32 f) public returns(int)
    {
        address addr=msg.sender;
        if(no_reg_players < no_of_players&&addr!=addr_host)
        {
            if(get_id(addr)==-1)
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
    function set_questions()
    {
        q_answers[1] = 1;
        q_answers[2] = 2;
        q_answers[3] = 3;
        q_answers[4] = 4;
    }
    
    function get_answer(int32 q) public returns(int32)
    {
        return q_answers[q];
    }
    function record_answer(int32 q,int32 ans) 
    {
       address addr = msg.sender;
       int32 id=get_id(addr);
       if(id!=-1)
        p_answers[q][id] = ans;
    }
    
    function get_aggr_fee()
    {
        aggr_fee=total_fee/no_reg_players;
    }
    
    function set_reward() public returns(int32)
    {
        return 1;
    }
    
    function check_answers()
    {
        if(msg.sender==addr_host)
        {
            while(round<=no_of_ques)
            {
                int32 ans=get_answer(round);
                for(int32 i=0;i<no_reg_players;i++)
                {
                    if(p_list[i].flag&&ans==p_answers[round][i])
                        p_list[i].reward+=set_reward();
                    else
                        p_list[i].flag=false;
                }
                round++;
            }
        }
    }
}