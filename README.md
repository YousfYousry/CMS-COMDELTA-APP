Overview: <br />
SSAOL app is built using flutter tool, and Dart is the programming language used to build it. The application sends post requests to get the data from mysql database using PHP language which is hosted using xamp on the server. Communication happens using Jason format. The app sends feedback emails using OAuth 2.0 and its token need to be changed every few months. To change the token, I have created a php file that will automatically generate the token when launched. The server monitors the devices if they went active or inactive using windows scheduler which needs to be turned on every time the server restart to continue monitoring. It monitors devices for clients and users separately, each has a separate php file that run together every 5 minutes using a bat file and it run all the time (First started on 25th of October 2021 at 420 pm :).

Features: <br />
- Google maps (to display locations of the devices). <br />
- Login as admin, user, or customer with encryption to keep data safe. <br />
- Displaying, Filtering, searching and analyzing data on the server. <br />
- Ability to modify, add or delete data on the database (mySql). <br />
- Pdf and excel exporting. <br />
- Real time monitoring for the status of the devices on the server. <br />
- Notification will be sent once changes of the data has been detected (e.g. device went inactive). <br />
- Some beatifull animations (thanks to flutter libraries). <br />

Screenshots:<br />
![image](https://user-images.githubusercontent.com/60311634/155440935-da4780d7-d46f-4183-9b8d-abad286a0d8e.png)
