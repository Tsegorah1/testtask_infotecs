from sources_python.create_packets import *


class Generator:
    byte_array = []
    byte_array_string = []
    ips_string = []
    ips = []
    packets = []
    def __init__(self, length_of_ips, allowed_number_of_packets, total_number_of_packets):
        self.create_rand(length_of_ips, allowed_number_of_packets, total_number_of_packets)

    def create_rand(self, length_of_ips, allowed_number_of_packets, total_number_of_packets ):
        create_random_ips(self.ips, length_of_ips)
        self.packets = create_random_packets(self.ips, allowed_number_of_packets, total_number_of_packets)
    def get_ips(self):
        for ip in self.ips:
            self.ips_string.append(ip[0] + ";" + ip[1] + ";" + str(ip[2]) + "\n")
        return self.ips_string

    def get_packets_array(self):
        return self.packets

    def get_packets_byte_array(self):
        for packet in self.packets:
            self.byte_array.append(bytes(packet))
        return self.byte_array

    def get_packets_string_array(self):
        for packet in self.packets:
            self.byte_array_string.append(' '.join(str(int(i)) for i in bytes(packet)) + "\n")
        return self.byte_array_string
