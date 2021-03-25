import os, requests, re, time, datetime

"""
Script that checks perimeter Netscaler server you're connected to. Use a regular expression to match the GET requests and decide the counter we need to increase.

Script specially made for Banc Sabadell.


Variables
"""

results_path = "C:\\Users\\jfernandez037\\Documents\\BSabadell\\LoadStats\\Results"
filename = 'LoadBalancerStats' + str(datetime.datetime.now().strftime("%m_%d_%y-%H_%M")) + '.txt'

perimeter_url = 'https://3.249.85.76/test_amb_token'
params = {'sessionKey': '23a5ff83db25760552acc4be124a92baeae12962103'}
perimeter_page = requests.post(perimeter_url, params=params)

test_length = 30
per01_count = 0
per02_count = 0

per01 = re.compile(r'01\b')
per02 = re.compile(r'02\b')

def check_perimeter(text):

    """
    Take the text from the GET and checks it against regular expressions.
    Depending on which regex matches, we increase the counter for that respective perimeter server.
    """

    global per01_count
    global per02_count
    if per01.search(text):
        per01_count += 1
    if per02.search(text):
        per02_count += 1
    return per01_count, per02_count

def prepare_statistics(a):

    """
    Percentage function
    """

    ratio = a / test_length * 100
    return ratio

"""
Iterate through both perimeters and print stats
"""

for x in range(test_length + 1):
    if x == test_length:
        per01_result = prepare_statistics(per01_count)
        per02_result = prepare_statistics(per02_count)
        l = open(os.path.join(results_path, filename), 'w')
        l.write('Testing URL: {0}\n'.format(perimeter_url))
        l.write('Test Length: {0}\n'.format(test_length))
        l.write('\n----Per01 Results----\n')
        l.write('Connection Percentage: {0}%\n'.format(per01_result))
        l.write('{0} connections made / {1} total attempted connections for this test\n'.format(per01_count, test_length))
        l.write('\n----Per02 Results----\n')
        l.write('Connection Percentage: {0}%\n'.format(per02_result))
        l.write('{0} connections made / {1} total attempted connections for this test\n'.format(per02_count, test_length))
        l.close()
    else:
        time.sleep(60) #DoS prevention to production servers
        check_perimeter(perimeter_page.text)