import re
from testinfra.utils.ansible_runner import AnsibleRunner

testinfra_hosts = AnsibleRunner('.molecule/ansible_inventory').get_hosts('all')


def test_dirs(File):
    assert File('/root/bin/').is_directory
    assert File('/root/scripts/').is_directory


def test_config(File):
    assert File('/root/bin/kubectl').is_symlink
    assert File('/root/scripts/kubectl-completion').is_symlink


def test_command_output(Command):
    command = Command('~/bin/kubectl version --short --client')
    assert re.search('Client Version: v\d+[.]\d+[.]\d+', command.stdout)
    assert command.rc == 0
