from sources_python.create_packets import *
from sources_python.filter_packets import *

ips = []
create_random_ips(ips, 8)
created_packets = create_random_packets(ips, 20, 40)
prefiltered_packets = [filter_packet((bytes(packet)), ips) for packet in created_packets]
filtered_packets = list(filter(lambda item: item is not None, prefiltered_packets))
print(len(filtered_packets))