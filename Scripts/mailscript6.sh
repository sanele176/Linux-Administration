#!/bin/bash

# Define variables
report_dir="/home/mancobd_sa/Automation"  # Adjust this path as necessary
email_subject="Unix Server Health Report"
email_to="testuser@test.com"
email_from="testuser@test.com"

# Start HTML body
html_body="
<html>
  <body>
    <h2>Unix Server Health Report</h2>
    <table border=\"1\" style=\"width:100%; border-collapse:collapse;\">
      <tr>
        <th style=\"background-color:#808080; color:white;\">Server</th>
        <th style=\"background-color:#808080; color:white;\">CPU Usage</th>
        <th style=\"background-color:#808080; color:white;\">Memory Usage</th>
        <th style=\"background-color:#808080; color:white;\">Disk Usage</th>
      </tr>
"

# Add reports from all servers
for file in "$report_dir"/*health_report.txt; do
  # Extract server name from the filename
  server_name=$(grep 'Host:' "$file" | awk -F': ' '{print $2}' | xargs)
  
  # Read content from the file (assuming it contains CPU, Memory, Disk usage)
  cpu_usage=$(grep 'CPU Usage' "$file" | awk -F': ' '{print $2}' | tr -d '%,' | xargs)
  memory_usage=$(grep 'Memory Usage' "$file" | awk -F': ' '{print $2}' | tr -d '%,' | xargs)
  disk_usage=$(grep 'Disk Usage' "$file" | awk -F': ' '{print $2}' | tr -d '%,' | xargs)

  # Apply inline color coding based on usage
  cpu_color=$( [ "$(echo "$cpu_usage < 80" | bc -l)" -eq 1 ] && echo "style='background-color:#03a818;color:white;'" || echo "style='background-color:#fa0d05;color:white;'" )
  memory_color=$( [ "$(echo "$memory_usage < 80" | bc -l)" -eq 1 ] && echo "style='background-color:#03a818;color:white;'" || echo "style='background-color:#fa0d05;color:white;'" )
  disk_color=$( [ "$(echo "$disk_usage < 80" | bc -l)" -eq 1 ] && echo "style='background-color:#03a818;color:white;'" || echo "style='background-color:#fa0d05;color:white;'" )

  # Add a row for this server with color-coded values
  html_body+="
      <tr>
        <td>$server_name</td>
        <td $cpu_color>$cpu_usage%</td>
        <td $memory_color>$memory_usage%</td>
        <td $disk_color>$disk_usage%</td>
      </tr>
"
done

# Close HTML body
html_body+="
    </table>
  </body>
</html>
"

# Send the email
(
echo "From: $email_from"
echo "To: $email_to"
echo "Subject: $email_subject"
echo "Content-Type: text/html"
echo ""
echo "$html_body"
) | /usr/sbin/sendmail -t
