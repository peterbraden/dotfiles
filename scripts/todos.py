"""
I keep a todo list as a plaintext file vaguely inspired by markdown but totally
idiosyncratic, and liable to evolve as my needs change.

Nonetheless it would be nice to be able to "parse" it.

A few python utils allow this to be simpler than my previous hackery with sed
and regex.
"""

from datetime import date


def load_todo(todofile):
    f = open(todofile)
    return f.readlines()


def find_section(line):
    if line.startswith("# "):
        return line[2:]
    if line.startswith("## "):
        return line[3:]

    return False


def todo_sections(todofile):
    file = load_todo(todofile)

    out = {"": []}
    current_section = ""

    for line in file:
        line = line.replace('\n', '')
        if find_section(line):
            current_section = find_section(line)
            out[current_section] = []
        else:
            out[current_section].append(line)

    return out 


def todo_today(todofile):
    sections = todo_sections(todofile)

    today = date.today()
    lowerkeys = {k: v for (k, v) in [(k.lower(), k) for k in sections.keys()]}
    
    day = today.strftime("%a").lower()
    if day in lowerkeys:
        items = '\n'.join(sections[lowerkeys[day]])
        return f'# {today}\n{items}'

    if day == 'thu' and 'thurs' in lowerkeys:
        items = '\n'.join(sections[lowerkeys['thurs']])
        return f'# {today}\n{items}'


    return ">>" + day

