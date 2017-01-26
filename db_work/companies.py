#! /usr/bin/env python
# -*- coding: utf-8 -*-

import debug
import _connect_info
import sys


class companies:
    name = 'name before init'

    def __init__(self, nameP):
        #debug.debug(0, "companies init start")
        #:type name: str
        assert isinstance(nameP, str)
        self.name = nameP
        #debug.debug(0, "companies init stop")

    def company_create(self):
        #debug.debug(0, "company_create start")
        connect = _connect_info.connect()
        cursor = connect.cursor()
        callproc_params = [self.name]
        #debug.debug(1, "company_create before try")
        try:
            #debug.debug(2, "company_create try block")
            cursor.callproc('sh_f_companies.company_create', callproc_params)
        except:
            #debug.debug(2, "company_create except block")
            result = 'Exception while executing: ', sys.exc_value
            i = 1
            connect.rollback()
        else:
            #debug.debug(2, "company_create else block")
            for row in cursor:
                i = row[0]
                #debug.debug(2, "callproc result = " + str(i))
            if i > 0:
                # !!!! make errror generation
                # print 'Execute company_create execption. Result = ',i
                connect.rollback()
                result = 'Mistake with data chekin in database. Need to show mistake text later'
            if i == 0:
                connect.commit()
                result = 'Excecution successfull'
        connect.close()
        #debug.debug(0, "company_create end")
        return i, result

    def company_search(self):
        #debug.debug(0, "company_search start")
        company_id = None
        i = 0
        connect = _connect_info.connect()
        cursor = connect.cursor()
        callproc_params = [self.name]
        #debug.debug(1, "company_search before try self.name = "+str(self.name))
        try:
            #debug.debug(2, "company_search try block")
            cursor.callproc('sh_f_companies.company_search', callproc_params)
        except:
            #debug.debug(2, "company_search except block")
            result = 'Exception while executing: ', sys.exc_value
            i = 1
            connect.rollback()
        else:
            #debug.debug(2, "company_search else block")
            for row in cursor:
                company_id = row[0]
                #debug.debug(2, "callproc result = " + str(i))
                connect.commit()
                result = 'Excecution successfull'
            if len(str(company_id)) == 0:
                i = 2
        connect.close()
        #debug.debug(0, "company_search stop result = "+str(result))
        return company_id, i, result

def companies_list():
    #debug.debug(1, "companies_list start")
    connect = _connect_info.connect()
    cursor = connect.cursor()
    cursor.execute("select * from sh_data.companies;")
    print "companies_list"
    for row in cursor:
        print(row)
    #print('exit')
    connect.close()


if __name__ == "__main__":
    print "module not for executing"
