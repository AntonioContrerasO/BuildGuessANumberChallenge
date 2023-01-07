#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$(( RANDOM % 1000 + 1 ))
echo $NUMBER
echo -e "Enter your username:"
read USERNAME
EXISTS=$($PSQL "SELECT username FROM number_guess WHERE username='$USERNAME'")
if [[ -z $EXISTS ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_NAME=$($PSQL "INSERT INTO number_guess(best_game,username) VALUES(10000,'$USERNAME')")
  BEST=10000
else
  GAMES=$($PSQL "SELECT games_played FROM number_guess WHERE username='$USERNAME'")
  BEST=$($PSQL "SELECT best_game FROM number_guess WHERE username='$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES games, and your best game took $BEST guesses."
fi
TRIES=1;
echo -e "\nGuess the secret number between 1 and 1000:"
while [[ $GUESS != $NUMBER ]]
  do
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"
    else
      if [[ $GUESS -gt $NUMBER ]]
      then
      TRIES=$(($TRIES+1))
        echo "It's lower than that, guess again:"
      elif [[ $GUESS -lt $NUMBER ]]
      then
      TRIES=$(($TRIES+1))
        echo "It's higher than that, guess again:"
      fi
    fi
  done
echo "You guessed it in $TRIES tries. The secret number was $NUMBER. Nice job!"
N_GAMES=$(($GAMES + 1))
if [[ $TRIES -lt $BEST ]]
then
      INSERT_GAME_DATA=$($PSQL "UPDATE number_guess SET games_played=$N_GAMES, best_game=$TRIES WHERE username='$USERNAME'")
else
      INSERT_GAME_DATA=$($PSQL "UPDATE number_guess SET games_played=$N_GAMES WHERE username='$USERNAME'")
fi
