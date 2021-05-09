# From MD TUTORIALS for Ligand and Protein Simulation

gmx trjconv -s md_30ns.tpr -f md_30ns.xtc -o md_center.xtc -center -pbc mol -ur compact # choose 1 and 0 (Protein for centering
# and System for Output)
echo 0 | gmx trjconv -s md_30ns.tpr -f md_center.xtc -o start.pdb -dump 0
gmx trjconv -s md_30ns.tpr -f md_center.xtc -o md_fit.xtc -fit rot+trans # choose 4 and 0 (Backbone for least square fit 
# and System for Output)