import pymysql.cursors
import pandas as pd

class DataImporter:

    def __init__(self, file_path:str, proc_name:str, column_mapping_order:list[str]):
        self.column_mapping_order = column_mapping_order
        self.file = open(file_path, 'r')
        self.proc_name = proc_name
        self.df = pd.read_csv(file_path)

    def insert_row(self, row, connection):
        with connection.cursor() as cursor:
            args = []
            for col in self.column_mapping_order:
                if type(col) is not str:
                    col_mapping = col['value']
                    str_converter = col['callable']
                    if not pd.isna(row[col_mapping]):
                        args.append(str_converter(row[col_mapping]))
                elif not pd.isna(row[col]):
                    args.append(row[col])
            if len(args) == len(self.column_mapping_order):
                cursor.callproc(self.proc_name, args)

    def data_import(self, connection):
        self.df.apply(self.insert_row, args=(connection,), axis=1)