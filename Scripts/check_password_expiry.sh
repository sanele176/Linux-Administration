#!/bin/bash

# loop through each user
for user in $(cat /etc/passwd | grep -E "/bin/bash" | grep -v -E "root" | cut -d: -f1)
do
          # get the current date in Unix time
 now=`date +%s`


              # get the password expiry date in Unix time
expires=`chage -l $user |grep -v -E "never" | awk -F: '/Password expires/{print $2}' | xargs -I {} date -d "{}" +%s`

                  # calculate the number of days left until the password expire
daysleft=$(( ($expires-$now)/(3600*24) ))

                      # send an email notification to the user when there are 10 days left before the password expires
                      if [ $daysleft -le 10 ] && [ "$expires" != ":never" ]
then

pass_status=$(chage -l $user | grep -E "Password expires" | awk '{print $4,$5,$6}')

mail -s "Password expiration reminder for user : $user" dsanele395@gmail.com <<< "Your password will expire in $pass_status . Please change your password as soon as possible $daysleft Days left".


fi
done
