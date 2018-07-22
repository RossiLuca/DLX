analyze -library WORK -format vhdl  {000-global.vhd}
analyze -library WORK -format vhdl  {001-functions.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.a-iv.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.b-nd2.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.c-mux21.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.d-mux21N.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.e-fa.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.f-rcaN.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.g-PGblock.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.h-G.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.i-PG.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.l-SparseTreeCarryGenN.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.m-CSBlockN.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.n-CarrySumN.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.o-AddSubN.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.p-SparseTreeCarryGenNBM.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.q-CSBlockNBM.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.r-CarrySumNBM.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.s-P4adderN.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.t-CSA.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.u-BoothMulWallace.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.v-Comp.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.z-LogicFun_v2.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.za-Mux2to1.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.zb-mux32to1.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.zc-bidir_shift_rot_N.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU.core/a.b.a.zd-bidir_shift_rot_N_interface.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.a-ALU_v2.vhd}

analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.c-fd_en.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.d-LatchEn.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.e-RegEn.vhd}

analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.h-mux41.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.i-mux41N.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.l-mux81.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.m-mux81N.vhd}
analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.n-mux161N.vhd}

analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.p-PC.vhd}


analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.q-registerfile.vhd}

analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.r-signExtension.vhd}

analyze -library WORK -format vhdl  {a.b-Datapath.core/a.b.s-zerotest.vhd}

analyze -library WORK -format vhdl  {a.b-datapath.vhd}

analyze -library WORK -format vhdl  {a.a-CU_HW.vhd}

analyze -library WORK -format vhdl  {a-DLX.vhd}

elaborate DLX -architecture Structure

create_clock -name "Clk" -period 2.97 Clk

compile -map_effort high

report_timing > Report_DLX_time_opt_time.txt
report_power > Report_DLX_time_opt_pow.txt
report_area > Report_DLX_time_opt_area.txt

write -hierarchy -format ddc -output DLX-structural-time-opt.ddc

create_clock -name "Clk" -period 3.5 Clk

compile -map_effort high -power_effort high

report_timing > Report_DLX_pow_time_opt_time.txt
report_power > Report_DLX_pow_time_opt_pow.txt
report_area > Report_DLX_pow_time_opt_area.txt

write -hierarchy -format ddc -output DLX-structural-time-pow-opt.ddc
