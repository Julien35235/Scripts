#Recuperation de l'espace de disque avec diskpart
reagentc /disable
diskpart
select disk 0
select partition 4
detail partition
#delete partition override
