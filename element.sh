#!/bin/bash

# Script for freeCodeCamp's 'Build a Periodic Database' project
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

QUIT(){
  echo $1
}

OUTPUT(){
  echo -e "The element with atomic number $1 is $2 ($3). It's a $4, with a mass of $5 amu. $2 has a melting point of $6 celsius and a boiling point of $7 celsius."
}

# feat/if-no-argument
if [[ -z $1 ]]; then
  QUIT "Please provide an element as an argument."
else
  # Check if the value is a number
  if [[ $1 =~ ^[0-9]+$ ]]; then
    # # feat/return-if-atomic-number
    IS_ATOMIC_NUMBER=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
    if [[ -z $IS_ATOMIC_NUMBER ]]; then
      QUIT "I could not find that element in the database."
    else
      IFS=' | '
      read -a ARR <<< "$IS_ATOMIC_NUMBER"
      OUTPUT ${ARR[1]} ${ARR[3]} ${ARR[2]} ${ARR[7]} ${ARR[4]} ${ARR[5]} ${ARR[6]}
    fi
  else
    IS_ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types using(type_id) WHERE symbol='$1' OR name='$1'")
    if [[ -z $IS_ELEMENT ]]; then
      QUIT "I could not find that element in the database."
    else
      IFS=' | '
      read -a ARR <<< "$IS_ELEMENT"
      OUTPUT ${ARR[1]} ${ARR[3]} ${ARR[2]} ${ARR[7]} ${ARR[4]} ${ARR[5]} ${ARR[6]}
    fi
  fi
  
fi
