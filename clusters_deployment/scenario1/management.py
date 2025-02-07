import subprocess
from enoslib.api import generate_inventory,run_ansible
from enoslib.infra.enos_vmong5k.provider import VMonG5k
from enoslib.infra.enos_vmong5k.configuration import Configuration

import logging
import time



name = "mcdeploymaster-sdfcp-21"

clusters = ["ecotype"]

#logging.basicConfig(level=logging.DEBUG)

master_nodes = []

duration = "8:00:00"


for i in range(0, len(clusters)):

    name_job = name + clusters[i] + str(i)

    role_name = "cluster" + str(clusters[i])
    
    conf = Configuration.from_settings(job_name=name_job,
                                       walltime=duration,
                                       image="/home/chuang/images/newimages.qcow2")\
                        .add_machine(roles=[role_name],
                                     cluster=clusters[i],
                                     flavour_desc={"core": 16, "mem": 32768},
                                     number=1)\
                        .finalize()
    provider = VMonG5k(conf)
    
    roles, networks = provider.init()

    inventory_file = "kubefed_inventory_cluster" + str(name_job) + ".ini" 

    inventory = generate_inventory(roles, networks, inventory_file)

    master_nodes.append(roles[role_name][0].address)

    # Make sure k8s is not already running
    #run_ansible(["reset_k8s.yml"], inventory_path=inventory_file)
    time.sleep(45)
    # Deploy k8s and dependencies
    run_ansible(["afterbuild.yml"], inventory_path=inventory_file)
    
f = open("node_list", 'a')
f.write(str(master_nodes[0]))
f.write("\n")
f.close
print("Master nodes ........")
print(master_nodes)