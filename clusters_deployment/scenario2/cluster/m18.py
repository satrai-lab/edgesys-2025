import subprocess
from itertools import islice
from enoslib.api import generate_inventory,run_ansible
from enoslib.infra.enos_vmong5k.provider import VMonG5k
from enoslib.infra.enos_vmong5k.configuration import Configuration

import logging
from pathlib import Path
import enoslib as en

import logging
import time

name = "m1-sdfcp-18"

clusters = "ecotype"

site = "nantes"

#en.init_logging(logging.INFO)

master_nodes = []

duration = "8:00:00"

prod_network = en.G5kNetworkConf(type="prod", roles=["my_network"], site=site)

name_job = name + clusters

role_name = "cluster" + str(clusters)

conf = (
    en.G5kConf.from_settings(job_type="allow_classic_ssh", job_name=name_job, walltime=duration)
    .add_network_conf(prod_network)
    .add_network(
        id="not_linked_to_any_machine", type="slash_22", roles=["my_subnet"], site=site
    )
    .add_machine(
    roles=["role0"], cluster=clusters, nodes=1, primary_network=prod_network
    ).finalize()
)
provider = en.G5k(conf)
roles, networks = provider.init()
roles = en.sync_info(roles, networks)

subnet = networks["my_subnet"]

for i in range(0,10):
    virt_conf = (
        en.VMonG5kConf.from_settings(image="/home/chuang/images/newimages.qcow2")
        .add_machine(
            roles=["cp"],
            number=1,
            undercloud=roles["role0"],
            flavour_desc={"core": 2, "mem": 4096},
            macs=list(subnet[0].free_macs)[i:i+1],
        ).finalize()
    )

    vmroles = en.start_virtualmachines(virt_conf)

    print(vmroles)

    #print(networks)
    tempname=name_job+str(i)

    inventory_file = "kubefed_inventory_cluster"+ str(tempname) +".ini" 

    inventory = generate_inventory(vmroles, networks, inventory_file)

    master_nodes.append(vmroles["cp"][0].address)

    # Make sure k8s is not already running
    #run_ansible(["reset_k8s.yml"], inventory_path=inventory_file)
    time.sleep(45)
    # Deploy k8s and dependencies
    run_ansible(["afterbuild.yml"], inventory_path=inventory_file)

f = open("node_list", 'a')
for i in range(0,10):
    f.write(str(master_nodes[i]))
    f.write("\n")
f.close