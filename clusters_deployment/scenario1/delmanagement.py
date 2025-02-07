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

duration = "04:00:00"


for i in range(0, len(clusters)):

    name_job = name + clusters[i] + str(i)

    role_name = "cluster" + str(clusters[i])
    
    conf = Configuration.from_settings(job_name=name_job,
                                       walltime=duration,
                                       image="/grid5000/virt-images/ubuntu2004-x64-min-2022032913.qcow2")\
                        .add_machine(roles=[role_name],
                                     cluster=clusters[i],
                                     flavour_desc={"core": 4, "mem": 16384},
                                     number=2)\
                        .finalize()
    provider = VMonG5k(conf)
    provider.destroy()