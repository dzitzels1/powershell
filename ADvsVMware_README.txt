I had an audit task to find all of our production servers.  I decided to create a script to compare our AD Computer objects vs what was in VMware as servers.  Why didn't I just grab the list out of VMware?  Because I wanted to see how much "junk" we had in AD as part of the process.  This script was designed to fulfill purpose.

We have the luxury of having just servers in our domain so that eased the development of this script immensely.  If you have a mix of client workstations and servers, you will have to structure the following query differently:

$computers = Get-ADComputer -Filter * -Properties * | Select-Object Name,DNSHostName,IPv4Address;

You may have to either add a -SearchBase variable or filter by operating system.  If you have both Linux and Windows AD Computer objects, you may have to write two queries and ammend the script to process both.

Hopefully this script gives you a good starting point.

Good luck and good scripting!
