# JobBeaconMaine
Students and new graduates struggle to discover relevant job opportunities in Maine's job market. This project will find and notify students of these opportunities.

## Roles & Contacts
|    Name     | Ellis (Team Lead)       | Jered        | Kadin       |
|------------|------------|-----------|-----------|
|   Email  | ellis.fitzgerald@maine.edu   | jered.kalombo@maine.edu | kadin.ilott@maine.edu  |

## Build

Clone repository and change directory
```
git clone https://github.com/EllisFitzUSM/JobBeaconMaine.git
cd JobBeaconMaine
```

Install requirements & dependencies.
```
pip install -r requirements.txt
```

Run `PhaseTwo/init.py` file to build the database, and optionally import the initial data. 

**WARNING: It is crucial to run from the root folder of the repository, as file paths are used and are relative.**

Usage: 
```
python PhaseTwo/init.py [<options>]
    --host              the database host
    --user              the database user
    --pw                the database pw
    --port value        the database port 
    --skip_drop         skip dropping tables (not recc)
    --index             use index files to index db
    --import_data       import provided data
```
The default execution (`python PhaseTwo/init.py`) is equivalent to
```
python PhaseTwo/init.py --host localhost --user root --pw passwd --port 3306
```