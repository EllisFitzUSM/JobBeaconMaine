def shorten_desc(str_val:str) -> str:
    return str_val[:2000]

def shorten_zip(str_val:str) -> str:
    return str_val[:5]

def shorten_app_url(str_val:str) -> str:
    return str_val[:300]

def get_city(str_val:str) -> str:
    return str_val[0:str_val.find(',')]