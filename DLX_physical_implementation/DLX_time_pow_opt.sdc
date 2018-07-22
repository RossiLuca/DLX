###################################################################

# Created by write_sdc on Tue Oct 17 14:57:36 2017

###################################################################
set sdc_version 1.7

create_clock [get_ports Clk]  -period 3.5  -waveform {0 1.75}
