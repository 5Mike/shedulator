#! /usr/bin/env python
# -*- coding: utf-8 -*-

import debug
import _connect_info
import sys
import companies as comp


class users:
    name = None
    company_id = None
    phone_num = None

    def __init__(self, nameP, company_nameP, phone_numP):
        debug.debug(0, "users init start")
        #:type name: str
        assert isinstance(nameP, str)
        self.cname = nameP
        debug.debug(2, "users init before if")
        if company_nameP is not None:
            company = comp.companies(company_nameP)
            self.company_id = company.company_search()
            debug.debug(2, "users init in if. Company search result = " + str(self.company_id))
        self.phone_num = phone_numP
        debug.debug(0, "users init stop")

    def user_create(self):
        debug.debug(0, "user_create start")
        print "user_create start"
        print "self.cname = ", self.cname
        print "self.company_id = ", self.company_id

        if self.cname is null:
            i, result = 1, "User name can not be null"
        elif self.company_id is null:
            i, result = 1, "Company can not be null"
        else:
            print "user create else"
            connect = _connect_info.connect()
            cursor = connect.cursor()
            callproc_params = [self.cname, self.company_id, self.phone_num]
            debug.debug(1, "user_create before try")
            try:
                debug.debug(2, "user_create try block")
                cursor.callproc('sh_f_users.user_create', callproc_params)
            except:
                debug.debug(2, "user_create except block")
                result = 'Exception while executing: ', sys.exc_value
                i = 1
                connect.rollback()
            else:
                debug.debug(2, "user_create else block")
                for row in cursor:
                    i = row[0]
                    debug.debug(2, "callproc result = " + str(i))
                if i > 0:
                    # !!!! make errror generation
                    # print 'Execute user_create execption. Result = ',i
                    connect.rollback()
                    result = 'Mistake with data chekin in database. Need to show mistake text later'
                if i == 0:
                    connect.commit()
                    result = 'Execution successfull'
            connect.close()
        debug.debug(0, "user_create end")
        return i, result


def companies_list():
    debug.debug(1, "companies_list start")
    connect = _connect_info.connect()
    cursor = connect.cursor()
    cursor.execute("select * from companies;")
    print "companies_list"
    for row in cursor:
        print(row)
    print('exit')
    connect.close()


if __name__ == "__main__":
    print "module not for executing"
