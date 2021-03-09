import subprocess, os
from subprocess import Popen
import time, sys
from pypsexec.client import Client

print ('###################################')
print ('#                                 #')
print ('#   Thycotic PSEXEC - CLI Tool    #')
print ('#                                 #')
print ('###################################')
print ('\n\n')

remote_host = input('Enter Remote Host: ')
tss_id = input ('Enter Secret ID: ')
comando = input('Command to run (executable): ')
argumento = input('Arguments (if any): ')
print ('\n')


os.chdir('c:\\disk\\tss')
tss_start = subprocess.run(['tss','init', '--url','https://server01.lab01.com/SecretServer/','-r','runasapi'],cwd='c:\\disk\\tss\\' ,stdout=subprocess.PIPE, shell = True)
wd = os.getcwd()
tss_start = str(tss_start.stdout)
tss_start = tss_start.replace("\\r\\n'","")
tss_start = tss_start.replace("b'","")

print ('Connecting to Secret Server in order to retrieve the credentials for the secret ID: ', '{', tss_id, '}')
print ('.........................................................................................')
print ('')

tss_domain = subprocess.run(['tss', 'secret','-s','10','-f','domain'], stdout=subprocess.PIPE, shell = False)
tss_domain = str(tss_domain.stdout)
tss_domain = tss_domain.replace("\\r\\n'","")
tss_domain = tss_domain.replace("b'","")

tss_account = subprocess.run(['tss', 'secret','-s','10','-f','username'], stdout=subprocess.PIPE, shell = False)
tss_account = str(tss_account.stdout)
tss_account = tss_account.replace("\\r\\n'","")
tss_account = tss_account.replace("b'","")

tss_pwd = subprocess.run(['tss', 'secret','-s','10','-f','password'], stdout=subprocess.PIPE, shell = False)
tss_pwd = str(tss_pwd.stdout)
tss_pwd = tss_pwd.replace("\\r\\n'","")
tss_pwd = tss_pwd.replace("b'","")

fulluser = tss_domain + "\\" + tss_account                          #"administrator@lab01.com"


c = Client(remote_host, username=fulluser, password=tss_pwd, encrypt=True)
c.connect()

try:
    c.create_service()
    #result = c.run_executable(executable, arguments=arguments)
    result = c.run_executable(comando, arguments=argumento)
    
finally:
    c.remove_service()
    c.disconnect()


print ("Running the command: '", comando + ' ' + argumento, "' on the host: ", "\\\\" + remote_host)
print ('.........................................................................................')
print ("\n%s" % result[0].decode('utf-8') if result[0] else "")
print ("STDERR:\n%s" % result[1].decode('utf-8') if result[1] else "")
#print ("RC: %d" % result[2])


