if [[ $# -eq 0 ]]; then
    echo "Please provide an element as an argument."
else
 ARGUMENT=$1
    PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
    if [[  $ARGUMENT =~ ^[0-9]+$ ]]
    then
      ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $ARGUMENT; ")
    elif [[ $ARGUMENT =~ ^[A-Z][a-z]?$ ]]
    then
      ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$ARGUMENT'; ")
    elif [[ $ARGUMENT =~ ^[A-Z][a-z]+$ ]]
    then
      ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$ARGUMENT'; ")
    fi
    if [[ -z $ELEMENT ]] 
    then
      echo "I could not find that element in the database."
    else
       echo "$ELEMENT" | while IFS=$'|' read AT_NUM NAME SYMBOL TYPE AT_MASS MELT_POINT BOIL_POINT
      do
        echo "The element with atomic number $AT_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AT_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
      done
    fi
fi