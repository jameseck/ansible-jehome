#!/usr/bin/python
import re
from copy import deepcopy
from random import Random
from ansible.module_utils.six import string_types
def random_mac(value, seed=None):
    ''' takes string prefix, and return it completed with random bytes
        to get a complete 6 bytes MAC address '''

    if not isinstance(value, string_types):
        raise AnsibleFilterError('Invalid value type (%s) for random_mac (%s)' % (type(value), value))

    value = value.lower()
    mac_items = value.split(':')

    if len(mac_items) > 5:
        raise AnsibleFilterError('Invalid value (%s) for random_mac: 5 colon(:) separated items max' % value)

    err = ""
    for mac in mac_items:
        if len(mac) == 0:
            err += ",empty item"
            continue
        if not re.match('[a-f0-9]{2}', mac):
            err += ",%s not hexa byte" % mac
    err = err.strip(',')

    if len(err):
        raise AnsibleFilterError('Invalid value (%s) for random_mac: %s' % (value, err))

    if seed is None:
        r = SystemRandom()
    else:
        r = Random(seed)
    # Generate random int between x1000000000 and xFFFFFFFFFF
    v = r.randint(68719476736, 1099511627775)
    # Select first n chars to complement input prefix
    remain = 2 * (6 - len(mac_items))
    rnd = ('%x' % v)[:remain]
    return value + re.sub(r'(..)', r':\1', rnd)

class FilterModule(object):
    def filters(self):
        return {
            'generate_macs': self.generate_macs,
        }

    def generate_macs(self, hosts_dict):
      new_hosts_dict = deepcopy(hosts_dict)
      for netw, val in new_hosts_dict.items():
        for h, v in val.items():
          new_hosts_dict[netw][h]['mac'] = random_mac('52:54:00', seed=h)
      return new_hosts_dict
