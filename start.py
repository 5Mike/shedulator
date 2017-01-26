#! /usr/bin/env python
# -*- coding: utf-8 -*-

#from bottle import route, run, template
import db_work.companies as comp
import db_work.users as usr

#@route('/hello/<name>')
#def index(name):
#    return template('<b>Hello {{name}}</b>!', name=name)


cmp = comp.companies("Unicorn")
res_code, res_mes = cmp.company_create()
print "company_create res_code = "+str(res_code)+"; res_mes = "+str(res_mes)
company_id, res_code, res_mes = cmp.company_search()
print "company_search company_id = "+str(company_id)+"; res_code = "+str(res_code)+"; res_mes = "+str(res_mes)

#user = usr.users("Admin_Kate","Unicorn","70123456789")
#res_code, res_mes = user.user_create ()
#print "res_code = "+str(res_code)+"; res_mes = "+str(res_mes)

comp.companies_list()

#run(host='localhost', port=8080)
"""CREATE OR REPLACE FUNCTION get_client_dlink(ppartner integer)
  RETURNS SETOF client_ret AS
$BODY$
#-*-  coding:utf-8 -*-
import kinterbasdb as kib

s = 'select param_link from partner_link where mode_link=0 and partner_id=$1'
plan = plpy.prepare(s, ['integer'])
param = plpy.execute(plan, [ppartner])

if not param:
    plpy.error('Partner not found')

param = param[0]['param_link'].split(';')

try:
  conn = kib.connect(dsn=param[0], user=param[1], password=param[2], dialect=3, charset='WIN1251')
except kib.OperationalError, er:
  plpy.error('Error DB: %s' % er)
except plpy.SPIError, er:
  plpy.error('Error: %s' % er)

curs = conn.cursor()
curs.execute("select guid, name from clients where type_clients=0 and active_flg='T'")

return [(row[0], row[1].encode('utf-8')) for row in curs]
$BODY$
  LANGUAGE 'plpythonu' ;"""