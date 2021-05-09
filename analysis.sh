# gmx trjcat -f md_30ns.xtc md_30ns.part002.xtc -o md_30ns_combined.xtc  - use this to combine trajectory files

gmx check -f md_30ns.xtc
tail md_30ns.log
# gmx view -f md_30ns.xtc -s md_30ns.tpr (to view animation of the trajectories)
gmx trjconv -f md_30ns.xtc -s md_30ns.tpr -o cluster.xtc -pbc cluster -dt 10 # choose 1 for cluster and 1 for output 
# (Protein in both cases)
gmx trjconv -f cluster.xtc -s md_30ns.tpr -o wild_protein_analysis.pdb -fit rot+trans # choose 4 for fitting and 1 for output
# (Backbone for fitting and Protein for output)
gmx energy -f md_30ns.edr -o temperature.xvg # choose 14 and hit enter twice
xmgrace temperature.xvg -hdevice PNG -hardcopy -printfile temperature.png
gmx energy -f md_30ns.edr -o kinetic_energy.xvg # choose 12 and hit enter twice
xmgrace kinetic_energy.xvg -hdevice PNG -hardcopy -printfile kinetic_energy.png
gmx energy -f md_30ns.edr -o potential_energy.xvg # choose 11 and hit enter twice
xmgrace potential_energy.xvg -hdevice PNG -hardcopy -printfile potential_energy.png
gmx energy -f md_30ns.edr -o volume.xvg # choose 21 and hit enter
xmgrace volume.xvg -hdevice PNG -hardcopy -printfile volume.png
echo 1 | gmx mindist -f md_30ns.xtc -s md_30ns.tpr -od minimal-periodic-distance.xvg -pi # choose 1 (Protein) and hit enter
xmgrace minimal-periodic-distance.xvg -hdevice PNG -hardcopy -printfile minimal-periodic-distance.png
echo 1 | gmx rmsf -f md_30ns.xtc -s md_30ns.tpr -o rmsf-per-residue.xvg -ox average.pdb -res # choose 1 (Protein) and hit enter
xmgrace -nxy rmsf-per-residue.xvg -hdevice PNG -hardcopy -printfile rmsf-per-residue.png
gmx rms -f md_30ns.xtc -s md_30ns.tpr -o rmsd-all-atom-vs-start.xvg -tu ns # choose 1 and 1 again (Protein is selected both times)
xmgrace rmsd-all-atom-vs-start.xvg -hdevice PNG -hardcopy -printfile rmsd-all-atom-vs-start.png
gmx rms -f md_30ns.xtc -s md_30ns.tpr -o rmsd-backbone-vs-start.xvg -tu ns # choose 4 and 4 again (Backbone is selected both times)
xmgrace rmsd-backbone-vs-start.xvg -hdevice PNG -hardcopy -printfile rmsd-backbone-vs-start.png
echo 1 | gmx trjconv -f md_30ns.xtc -s md_30ns.tpr -o peptide.xtc
gmx rms -f peptide.xtc -s average.pdb -o rmsd-all-atom-vs-average.xvg -tu ns # choose 1 and 1 again (Protein both times)
xmgrace rmsd-all-atom-vs-average.xvg -hdevice PNG -hardcopy -printfile rmsd-all-atom-vs-average.png 
gmx rms -f peptide.xtc -s average.pdb -o rmsd-backbone-vs-average.xvg -tu ns # choose 4 and 4 again (Backbone both times)
xmgrace rmsd-backbone-vs-average.xvg -hdevice PNG -hardcopy -printfile rmsd-backbone-vs-average.png
echo 1 | gmx gyrate -f md_30ns.xtc -s md_30ns.tpr -p -o radius-of-gyration.xvg
xmgrace radius-of-gyration.xvg -hdevice PNG -hardcopy -printfile radius-of-gyration.png
gmx hbond -f md_30ns.xtc -s md_30ns.tpr -num hydrogen-bonds-intra-peptide.xvg # choose 1 and 1 (Protein both times)
xmgrace -nxy hydrogen-bonds-intra-peptide.xvg -hdevice PNG -hardcopy -printfile hydrogen-bonds-intra-peptide.png
gmx hbond -f md_30ns.xtc -s md_30ns.tpr -num hydrogen-bonds-peptide-water.xvg # choose 1 and 12 (Protein and then Water)
xmgrace -nxy hydrogen-bonds-peptide-water.xvg -hdevice PNG -hardcopy -printfile hydrogen-bonds-peptide-water.png
export DSSP=/usr/bin/dssp 
echo 1 | gmx do_dssp -f md_30ns.xtc -s md_30ns.tpr -ver 2 -o secondary-structure.xpm -sc secondary-structure.xvg -dt 10
gmx xpm2ps -f secondary-structure.xpm -o secondary-structure.eps
xmgrace -nxy secondary-structure.xvg -free -hdevice PNG -hardcopy -printfile secondary-structure.png
gmx rama -f md_30ns.xtc -s md_30ns.tpr -o ramachandran.xvg
xmgrace ramachandran.xvg -hdevice PNG -hardcopy -printfile ramachandran.png
gmx rms -s md_30ns.tpr -f md_30ns.xtc -f2 md_30ns.xtc -m rmsd-matrix.xpm -dt 10 # choose 1 and 1 (Protein both times)
gmx xpm2ps -f rmsd-matrix.xpm -o rmsd-matrix.eps

# Select 1 and 1 (Protein both times)
gmx cluster -s md_30ns.tpr -f md_30ns.xtc -dist rmsd-distribution.xvg -o cluster.xpm -sz cluster-sizes.xvg -tr cluster-transitions.xpm -ntr cluster-transitions.xvg -clid cluster-id-over-time.xvg -cl clusters.pdb -cutoff 0.25 -method gromos -dt 10


echo 1 | gmx rmsdist -s md_30ns.tpr -f md_30ns.xtc -o distance-rmsd.xvg
xmgrace distance-rmsd.xvg -hdevice PNG -hardcopy -printfile distance-rmsd.png
echo 1 | gmx rmsdist -s md_30ns.tpr -f md_30ns.xtc -rms rmsdist.xpm -mean rmsmean.xpm -dt 10
gmx xpm2ps -f rmsdist.xpm -o rmsdist.eps
gmx xpm2ps -f rmsmean.xpm -o rmsmean.eps
echo 1 | gmx rmsdist -s md_30ns.tpr -f md_30ns.xtc -nmr3 nmr3.xpm -nmr6 nmr6.xpm -noe noe.dat -dt 10




# Second Set of Analysis from MD TUTORIALS.

gmx trjconv -s md_30ns.tpr -f md_30ns.xtc -o md_noPBC.xtc -pbc mol -center # Select 1 for Protein as group for centering
# and then 0 for System as Output
gmx rms -s md_30ns.tpr -f md_noPBC.xtc -o md_rmsd.xvg -tu ns # Select 4 and 4 (Backbone both times)
gmx rms -s em.tpr -f md_noPBC.xtc -o md_rmsd_xtal.xvg -tu ns # Select 4 and 4 (Backbone both times)
xmgrace md_rmsd.xvg md_rmsd_xtal.xvg -free -hdevice PNG -hardcopy -printfile rmsd_ce.png
echo 1 | gmx gyrate -s md_30ns.tpr -f md_noPBC.xtc -o md_gyrate.xvg




# Third Set of Analysis from STRODEL LAB

gmx trjconv -f md_30ns.xtc -s md_30ns.tpr -o md_protein.xtc -center -ur compact -pbc mol # Select 1 both for centering and Output
# Select Protein both times
gmx trjconv -f md_30ns.xtc -s md_30ns.tpr -o md_protein.pdb -center -ur compact -pbc mol -dump 0 # Choose 1 for Centering and Output
# Select Protein both times
echo 1 | gmx convert-tpr -s md_30ns.tpr -o md_protein.tpr
gmx rms -f md_protein.xtc -s md_protein.pdb -o protein_rmsd.xvg # Select 1 for Protein both times
echo 1 | gmx rmsf -f md_protein.xtc -s md_protein.pdb -o protein_rmsf.xvg
echo 1 | gmx gyrate -f md_protein.xtc -s md_protein.pdb -o protein_gyrate.xvg


# PLOTTING
# Create template.par file that contains the legend labels for the plot


#template.par : 
#with g0
#    s0 legend "P124S_protein"
#    s1 legend "P124S_complex"


xmgrace -param template.par P124S_protein/protein_rmsd.xvg P124S_complex/protein_rmsd.xvg # Ctrl + L to move legend, View - Page Setup
# to change Output device to PNG and set Output filename then Apply and Accept. Ctrl + P to generate output file. 
# Double Click on black marker at top-right corner of graph to expand the graph.
xmgrace -param template.par P124S_protein/protein_rmsf.xvg P124S_complex/protein_rmsf.xvg
xmgrace -block P124S_protein/protein_gyrate.xvg -bxy 1:2 -block P124S_complex/protein_gyrate.xvg -bxy 1:2 -param template.par

# EXTRACT TRAJECTORIES
gmx trjconv -s md_30ns.tpr -f md_30ns.xtc -dt 1000 -center -ur compact -pbc mol -o wild_prot_traj.pdb # Choose 1 and 1 
# (Protein for Centering and Output)

