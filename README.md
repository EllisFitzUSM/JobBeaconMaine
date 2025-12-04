# JobBeaconMaine
Students and new graduates struggle to discover relevant job opportunities in Maine's job market. This database fullstack application project will find and notify students of these opportunities.

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
**WARNING: Jupyter notebooks are used, which does not install all requirements.**

Run [`PhaseTwo/init.py`](PhaseTwo/init.py) file to build the database, and optionally import the initial data. 

**WARNING: It is crucial to run from the root folder of the repository, as relative file paths are used in this step.**

Usage: 
```
python PhaseTwo/init.py [<options>]
    --host              the database host
    --user              the database user
    --pw                the database pw
    --port value        the database port 
    --index             use index files to index db
    --import_data       import provided data
    --skip_drop         skip dropping tables and procedures (not recc)
```
The default execution (`python PhaseTwo/init.py`) is equivalent to
```
python PhaseTwo/init.py --host localhost --user root --pw passwd --port 3306
```
For taking advantage of the entire build, you most likely will want to do the following:
```
python PhaseTwo/init.py --host {host} --user {user} --pw {password} --port {port} --index --import_data
```

## Scraping & Data Cleaning
There are multiple scripts which execute scraping, so there is not a single command which can execute all scraping sources. Some scripts utilize API keys, so they cannot be executed by default. I highly recommend you take a look at [`PhaseTwo/Docs`](PhaseTwo/Docs) which contains information on scraping for each script. 
