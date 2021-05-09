gmx pdb2gmx -f 6tsz_wild_protein.pdb -o wild_processed.gro -ff amber99sb -water tip3p -ignh
gmx editconf -f wild_processed.gro -o wild_newbox.gro -c -d 1.0 -bt cubic
gmx solvate -cp wild_newbox.gro -cs spc216.gro -o wild_solv.gro -p topol.top
gmx grompp -f ions.mdp -c wild_solv.gro -p topol.top -o ions.tpr
echo 13 | gmx genion -s ions.tpr -o wild_solv_ions.gro -p topol.top -pname NA -nname CL -neutral
gmx grompp -f minim.mdp -c wild_solv_ions.gro -p topol.top -o em.tpr
gmx mdrun -v -deffnm em

# To be Run
gmx grompp -f nvt.mdp -c em.gro -p topol.top -o nvt.tpr
gmx mdrun -v -deffnm nvt
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
gmx mdrun -v -deffnm npt
gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr
gmx mdrun -v -deffnm md_0_1
