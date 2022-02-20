# COI blast Notes
30 COI sequences found by Dahiana
Blasted against database made of 270 sequences from Orr et al 2019
of those
5 unuseable (no blast hits) probably because too short
  - Rhinoliparis_attenuatus_UW_115871_96bp_l39
  - Allocareproctus_unangas_UW_150790_144bp_l66
  - Careproctus_n_sp_a_UW_154503_144bp_l66
  - Careproctus_faunus_UW_117078_150bp_l66
  - Paraliparis_mento_UW_150606_144bp_l66
4 no match because not included in database/Orr 2019
  - Careproctus_ectenes_UW_150772_276bp_l276 --4
  - Careproctus_ectenes_UW_153151_708bp_l708 --1
  - Paraliparis_holomelas_UW_153155_504bp_l504 --3
  - Careproctus_curilanus_UW_153150_528bp_l528 --2
16 had top match with same species (118920 listed as melanurus in db but actually ambustus so OK)
  - Allocareproctus_ungak_UW_111933_492bp_l492
  - Careproctus_simus_UW_154482_3_234bp_l234
  - Careproctus_melanurus_or_UW_150588_348bp_l348
  - Progn_ptycho_UW_116036_735bp_l735
  - Careproctus_lerikimae_UW_117918_351bp_l351
  - Paraliparis_cephalus_UW_153529_648bp_l648
  - Careproctus_simus_UW_154482_2_243bp_l243
  - Paraliparis_garmani_UW_118897_153bp_l153
  - Careproctus_ambustus_ai_UW_152101_573bp_l573
  - Liparis_fabricii_UW_153118_639bp_l639
  - Liparis_florae_UW_151666_480bp_l480
  - Paraliparis_dactylosus_UW_153045_333bp_l333
  - Careproctus_ambustus_goa_UW_154478_279bp_l279
  - Liparis_cyclopus_UW_151759_675bp_l675
  - Liparis_pulchellus_UW_115848_504bp_l504
  - Liparis_tunicatus_UW_153126_420pb_l420
5 had top hit other than self and of that 1 was problematic and removed from downstream analysis
  - Careproctus_faunus_UW_156084_465bp_l465 top hit C.comus second hit C.faunus -> sister spp so likely ok
  - Rhinoliparis_barbulifer_UW_157184_549bp_l549 top hit C.comus -> PROBLEM
  - Liparis_ochotensis_UW_49438_375bp_l375 top hit L.bristolensis -> inquire
    - only aligns for 294-492 (198 bp) but alignment doesn't look great so might just be misaligned; ok to keep
  - Liparis_gibbus_UW_153834_2_705bp_l705 top hit L.fabricii -> inquire
    - aligns from 159-492 (333 bp) of those 23 (7%) line up with fabricii and not gibbus
  - Liparis_gibbus_UW_153834_678bp_l678 top hit L.fabricii -> inquire
    - aligns from 87-492 (405 bp) of those 24 (6%) line up with fabricii and not gibbus
    - Gibbus in db from south of bering strait (n=2), in bering strait (n=1) and chuchki sea (69.2 N, n=1)
    - my gibbus from Chucki at 72 N
    - fabricii from N atalantic (n=4) or chucki (n=2, 73-74 N)
    - my fabricii from Chukchi 71 N -160
    - possible my gibbus is misid very tiny but given overall issues with tree not the main concern right now  also not falling out with other fabricii so something different probably.
