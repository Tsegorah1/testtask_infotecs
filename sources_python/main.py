from sources_python.generator import Generator


def write_to_txt():
    g = Generator(8,500,1000)
    with open('bytes.txt', 'w') as f:
        f.writelines(g.get_packets_string_array())
    with open('ips.txt', 'w') as f:
        f.writelines(g.get_ips())


if __name__ == "__main__":
    write_to_txt()
