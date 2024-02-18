import struct
from random import *
from scapy.layers.inet import IP
from scapy.layers.l2 import Ether
from faker import Faker


def create_random_packets(allowed_ips, allowed_number_of_packets, total_number_of_packets):
    packets = []
    for i in range(total_number_of_packets):
        if i < allowed_number_of_packets:
            ip = choice(allowed_ips)
            packets.append(IP(src=ip[0], dst=ip[1]))
        else:
            faker = Faker()
            packets.append(IP(dst=faker.ipv4(), src=faker.ipv4()))
    shuffle(packets)
    return packets


def get_number_of_allowed_packets(allowed_ips, packets):
    all_ips = []
    number_of_packets = 0
    for packet in packets:
        all_ips.append(packet.getlayer(IP).dst)
    for allowed_ip in allowed_ips:
        number_of_packets = number_of_packets + all_ips.count(allowed_ip)
    return number_of_packets


def create_random_ips(allowed_ips, length):
    for i in range(length):
        faker = Faker()
        allowed_ips.append((faker.ipv4(), faker.ipv4(), i+1))
