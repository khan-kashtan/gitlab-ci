import json

with open('temp.json', 'r') as f:
    start_dict = f.read()
    json_dict  = json.loads(start_dict)
    ip_result  = json_dict['gitlab_host']['hosts']
    ip_final   = str(ip_result)[3:-2]
    print(ip_final)
