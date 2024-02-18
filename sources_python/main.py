from cocotb.runner import get_runner
from pathlib import Path


def test_runner():
    proj_path = Path(__file__).parent.parent.resolve()
    vhdl_sources = [
        proj_path / 'sources_vhdl/old/PCK_CRC32_D32.vhd',
        proj_path / 'sources_vhdl/old/types_pack_old.vhd',
        proj_path / 'sources_vhdl/old/types_pack.vhd',
        proj_path / 'sources_vhdl/l2_network_encryptor.vhd',
    ]
    verilog_sources = [
        proj_path / 'sources_sv/afifo.v'
    ]
    runner = get_runner("questa")
    runner.build(
        vhdl_sources=vhdl_sources,
        verilog_sources=verilog_sources,
        hdl_toplevel="l2_network_encryptor",
        #build_args=["-cover", "bcst"],
        build_args=["--default-language", "1800-2017", "-Wno-WIDTHEXPAND", "-Wno-CASEINCOMPLETE", "--coverage"],
        includes=[proj_path],
        always=True,
    )
    extra_env = {'--coverage': 'True'}
    runner.test(
        test_module='test_top',
        hdl_toplevel="l2_network_encryptor",
        gui=True,
        waves=True,
        test_args=["--coverage", "--default-language", "1800-2017"],
        extra_env=extra_env,
    )


if __name__ == "__main__":
    test_runner()
