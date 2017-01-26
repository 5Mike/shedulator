import psycopg2
import debug

__conn_par = ['shedulator', 'postgres', 'localhost', 'postgres1']

def connect():
    debug.debug(1,"connect start")
    connect = psycopg2.connect(database = __conn_par[0]
                               , user = __conn_par[1]
                               , host = __conn_par[2]
                               , password = __conn_par[3])
    return connect