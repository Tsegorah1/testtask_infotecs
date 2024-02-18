import ipaddress
import struct
import socket
import pandas as pd
from scapy.layers.inet import IP
from scapy.utils import *
from scapy.layers.l2 import Ether
from scapy.packet import Packet, Raw, ls


def convert_bytes_to_csv(packet):
    df = pd.read_table()
    df.to_csv('data.csv')


def ethernet_frame_mac(data):
    dest_mac, src_mac, proto = struct.unpack('! 6s 6s H', data[:14])
    return get_mac_addr_fct(dest_mac), get_mac_addr_fct(src_mac), socket.htons(proto), data[14:]


def ethernet_frame_ips(data):
    header_values = struct.unpack(">BBHHHBBHII", data[:20])
    return ipaddress.ip_address(header_values[8]), ipaddress.ip_address(header_values[9])


def get_mac_addr_fct(bytes_addr):
    bytes_str = map('{:02x}'.format, bytes_addr)
    mac_addr = ':'.join(bytes_str).upper()
    return mac_addr


def filter_packet(packet, ips):
    ip_address = ethernet_frame_ips(packet)
    status = False
    for ip in ips:
        if (ip[0] == ip_address[0].exploded) & (ip[1] == ip_address[1].exploded):
            status = True
            pkt = IP(packet)
            byte_array = bytearray(ip[2])
            byte_array[-1:] = ip[2].to_bytes(1, 'little')
            new_packet = pkt / Raw(load=byte_array)
            del new_packet.chksum
            del new_packet.len
            new_packet = new_packet.__class__(bytes(new_packet))
            return bytes(new_packet)
    if not status:
        return None


def filter_packets(packets, ips):
    return list(filter(lambda item: item is not None, [filter_packet((bytes(packet)), ips) for packet in packets]))