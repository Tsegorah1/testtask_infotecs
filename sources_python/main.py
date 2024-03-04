from sources_python.generator import Generator


def write_to_txt():
    g = Generator(8,500,1000)
    with open('../questa_project/messages.txt', 'w') as f:
        f.writelines(g.get_packets_string_array())
    with open('../questa_project/ip_table.txt', 'w') as f:
        my_string = "".join(str(element) for element in g.get_ips())
        f.writelines(my_string.replace('.', ' '))


if __name__ == "__main__":
    write_to_txt()
