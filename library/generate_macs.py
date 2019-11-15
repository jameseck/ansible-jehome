#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

ANSIBLE_METADATA = {
    'metadata_version': '1.1',
    'status': ['preview'],
    'supported_by': 'james.eckersall@gmail.com'
}

DOCUMENTATION = '''
---
module: generate_macs

short_description: This takes a dict of hosts and adds generated mac addresses to them

version_added: "2.7"

description:
    - "This is very bespoke to my environment"

options:
    hosts_dict:
        description:
            - The dict to generate macs on
        required: true

author:
    - James Eckersall (james.eckersall@gmail.com)
'''

EXAMPLES = '''
# Pass in a message
- name: Test with a message
  my_new_test_module:
    name: hello world

# pass in a message and have changed true
- name: Test with a message and changed output
  my_new_test_module:
    name: hello world
    new: true

# fail the module
- name: Test failure of the module
  my_new_test_module:
    name: fail me
'''

RETURN = '''
hosts_dict:
    description: The dict with generated macs
    type: dict
'''

import re
from copy import deepcopy
from random import Random
from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils.six import iteritems, string_types, integer_types, reraise


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

def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        hosts_dict=dict(type='dict', required=True),
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # change is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        hosts_dict={}
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        return result

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    #result['original_message'] = module.params['name']
    #result['message'] = 'goodbye'
    result['hosts_dict'] = deepcopy(module.params['hosts_dict'])
    for netw, val in result['hosts_dict'].items():
      for h, v in val.items():
        result['hosts_dict'][netw][h]['mac'] = random_mac('52:54:00', seed=h)

    #result['hosts_dict'] = module.params['hosts_dict']

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
#    if module.params['name'] == 'fail me':
#        module.fail_json(msg='You requested this to fail', **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)

def main():
    run_module()

if __name__ == '__main__':
    main()
