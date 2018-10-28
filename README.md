# blockchain_assignment-quiz
A smart contract for an online quiz.
Quiz consists of 4 rounds base on elimination.
If P out of N players answer correctly for the question of round R then only these P players can play for further rounds.
Each round has one question and has 4 possible answers out of which one is correct.
The contract stores the correct option number corresponding to each question.
The contract records the answers of the players for all the questions. 
If a player p answers incorrectly for the question of round r ,then no answers are considered for further rounds for this player p and he ends up with reward for r-1 rounds only.
