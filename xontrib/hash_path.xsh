# coding:utf-8

import os, sys

from xonsh.dirstack import cd as _cd

# 把具体的路径映射成一个短的路径
# 快速 cd 到常用的路径
hash_path_map = {}

def add_hash_path(name, path):
    if not path:
        print('file path is empty\n', file=sys.stderr)
        return False
    if not name:
        print('path short name is empty\n', file=sys.stderr)
        return False

    if os.path.isfile(path):
        print('%s is not directory\n' % path, file=sys.stderr)
        return False 

    hash_path_map[name] = path
    return True

def get_hash_path(name):
    if not name:
        print('path short name is empty\n', file=sys.stderr)
        return False

    return hash_path_map.get(name, '')

def list_hash_path():
    str_list = []
    for key, value in hash_path_map.items():
        line = '%s\t:\t\t%s\n' % (key, value)
        str_list.append(line)

    return ''.join(str_list)

def _hash_path(args, stdin, stdout):
    args_len = len(args)
    if args_len == 0:
        m = list_hash_path()
        return m, '', 0

    if args_len != 2:
        return '', 'hash path must takes 2 arguments\n', 1

    add_hash_path(args[0], args[1])
    return None, None, 0

aliases['hash_path'] = _hash_path

# bcd aliases
def _bcd(args, stdin, stdout):
    if len(args) != 1:
        return '', 'bcd takes 1 argments, not %d'.format(len(args)) , 1

    path = args[0]
    real_path = get_hash_path(path)
    if not real_path:
        return '', 'not support hash path %s\n' % name, 1

    return _cd([real_path])

aliases['bcd'] = _bcd

def hash_path_completer(prefix, line, begidx, endidx, ctx):
    """
    completers bcd alias 
    """

    if not line.startswith('bcd'):
        return

    keys = hash_path_map.keys()

    return keys

__xonsh_completers__['hash_path'] = hash_path_completer
__xonsh_completers__.move_to_end('hash_path', last=False)
