from sources_python.create_packets import *


class Generator:
    def __init__(self):
        self.packet_randomized = SimPackets()

    def build(self):
        self.packet_randomized.create_rand()

    def get_packets(self):
        return self.packet_randomized

    def get_packets_array(self):
        return self.packet_randomized.packets

class SimPackets:
    ips = []
    packets = []

    def create_rand(self, length_of_ips, allowed_number_of_packets, total_number_of_packets ):

        create_random_ips(self.ips, length_of_ips)

        self.packets = create_random_packets(self.ips, allowed_number_of_packets, total_number_of_packets)
