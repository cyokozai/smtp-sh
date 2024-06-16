#!/bin/bash

# OpenSSL PASS
OPENSSL="/usr/bin/openssl"

# SMTP Server Host and Port
SMTP_HOST="smtp.gmail.com"
SMTP_PORT="465"
HELLO=""

#----------LOGIN ACCOUNT------------------------------------------------------------------------------#
USER=""
PASS=""
#-----------------------------------------------------------------------------------------------------#

#----------MAIL INFO----------------------------------------------------------------------------------#
SENDER=""
RECIPIENT=""
SUBJECT=""
CONTEXT=""
#-----------------------------------------------------------------------------------------------------#

# ENCODING BASE64
ENCODED_USER=$(echo  "$USER" | openssl enc -e -base64)
ENCODED_PASS=$(echo  "$PASS" | openssl enc -e -base64)
ENCODED_SUBJECT=$(echo -e "$SUBJECT" | openssl enc -e -base64)
ENCODED_CONTEXT=$(echo -e "$CONTEXT" | openssl enc -e -base64)

# SMTP PROTOCOL
function send_smtp_command {
    # SMTP Server Connection
    echo "HELO $HELLO"
    sleep 1

    # AUTHENTICATION LOGIN 
    echo "AUTH LOGIN"
    sleep 1
    echo "$ENCODED_USER"
    sleep 1
    echo "$ENCODED_PASS"
    sleep 1

    # Sender and Resipient
    echo "MAIL FROM: <$SENDER>"
    sleep 1
    echo "RCPT TO: <$RECIPIENT>"
    sleep 1

    # MAIL DATA
    echo "DATA"
    sleep 1

    # Content Setting
    echo "Content-Type: text/plain; charset=UTF-8"
    echo "Content-Transfer-Encoding: base64"
    sleep 1

    # Mail Header
    echo "To: $ENCODED_RECIPIENT"
    echo "From: $SENDER"
    echo "Subject: $SUBJECT"
    sleep 1

    # Mail Context
    echo "Content-Transfer-Encoding: base64"
    echo -e "$ENCODED_CONTEXT"
    echo "."
    sleep 1

    # End
    echo "QUIT"
}

# Send Mail
send_smtp_command | $OPENSSL s_client -connect "$SMTP_HOST":"$SMTP_PORT" -crlf -ign_eof
