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

## Install
>**WARNING:** Jupyter notebook requirements *will not be* installed. Though, these are not necessary to run the application.

Unix based machines (Linux, Mac)
```
source ./install.sh
```
Windows
```
install.bat
```

## Run
>**WARNING:** Running the **run** script with no arguments will assume a root user "admin" with password "admin." See [debugging](#debugging) if your configurations differ.

Unix based machines (Linux, Mac)
```
bash ./run.sh
```
Windows
```
run.bat
```

### Debugging
For the run script you can append additional arguments if your database root and password differ from the default.
```
--d [<user>] [<password>]
```
