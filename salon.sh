#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "\nWelcome to My Salon, how can I help you?\n"


SERVICES () {

  if [[ $1 ]] 
  then
    echo $1
  fi

  echo -e "How can I help you?\n"
  
  SERVICE_ID=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICE_ID" | sed "s/ |/)/"
  read SELECTED_ID
  
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id =$SELECTED_ID")

  if [[ -z $SERVICE_NAME ]]
  then 
    SERVICEs "I could not find that service. What would you like today?"
  else 
    CUSTOMER_MENU
  fi
}

CUSTOMER_MENU () {
  echo -e "\nWhat's your phone number?"
  read PHONE
  
  NAME=$($PSQL "SELECT name FROM customers WHERE phone='$PHONE'")

  if [[ -z $NAME ]]
  then
    echo -e "\nI don't have a record for that phone number. what's your name?"
    read NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers (name,phone) VALUES ('$NAME','$PHONE')")
  fi

  APPOINTMENT
  
}

APPOINTMENT () {
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$PHONE'")

echo -e "\nWhat time would like your $(echo $SERVICE_NAME| sed 's/^ *//'), $NAME?"
read APPOINTMENT_TIME
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID,'$APPOINTMENT_TIME')")
echo -e "\nI have put you down for a $(echo $SERVICE_NAME| sed 's/^ *//') at $APPOINTMENT_TIME, $NAME."

}

SERVICES
