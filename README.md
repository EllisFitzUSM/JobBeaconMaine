# JobBeaconMaine
Students and new graduates struggle to discover relevant job opportunities in Maine's job market. This database fullstack application project will find and notify students of these opportunities.

## Roles & Contacts
|    Name     | Ellis (Team Lead)       | Jered        | Kadin       |
|------------|------------|-----------|-----------|
|   Email  | ellis.fitzgerald@maine.edu   | jered.kalombo@maine.edu | kadin.ilott@maine.edu  |


## Clone repository and change directory
```
git clone https://github.com/EllisFitzUSM/JobBeaconMaine.git
cd JobBeaconMaine
```

## Software Dependencies

This project is dependent on an installation of Node.js with NPM, and Python.

<img src =https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/node_js.png width=100> <img src =https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/npm.png width=100> <img src=https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/python.png width=100>

You can view installation steps for your platform [here](https://nodejs.org/en/download), and [here](https://www.python.org/downloads/) respectively.

Unfortunately, there is no reliable way to have the user download Node.js on demand in this project, unless the user has NVM. Though, this does not avoid the original problem because similarly the user must download NVM on their own. Similar satements could be said about Python. Additionally, these are softwares that we assume one would not want installed unless the user is explicility aware We apologize for this inconvenience and extra step you have to take to view our application.

Once you have downloaded Node.js with NPM, and Python, make sure their PATH aliases are recognized in your terminal/shell so you can continue to the next steps.

## Install
This step will create a virtual environment (if not present) in the directory. Then, it will install the necessary Python libraries and Node modules.
>**WARNING:** Jupyter notebook requirements *will not be* installed. Though, these are not necessary to run the application.

__Unix based (Linux, Mac)__
```
source ./install.sh
```
__Windows__
```
install.bat
```

## Run
This step will build the database from scratch by running SQL files seen in the repository at a predetermined order. Then, create procedures will be called with scraped data to populate the database. Finally, the Flask backend app will run, and then subsequently the React frontend.
>**WARNING:** Running the **run** script with no arguments will assume a root user "admin" with password "admin." See [debugging](#debugging) if your configurations differ.

__Unix based (Linux, Mac)__
```
bash ./run.sh
```
__Windows__
```
run.bat
```

After you run, you should see something like this
```
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on http://127.0.0.1:5000
Press CTRL+C to quit
 * Restarting with stat

> frontend@1.0.0 dev
> vite

 * Debugger is active!
 * Debugger PIN: 131-420-912

  VITE v7.2.6  ready in 475 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
  ➜  press h + enter to show help
```
Ctrl/Cmd + Click the local link to view the webpage.

### Debugging
For the run script you can append additional arguments if your database root and password differ from the default.
```
--d [<user>] [<password>]
```
