drop node pg_dn7
drop node pg_dn8
drop node pg_dn10
drop node pg_dn11
drop node pg_dn12

drop node group gp7;
drop node group gp8;
drop node group gp10;
drop node group gp11;
drop node group gp12;

create node pg_cd7 with(TYPE=coordinator, HOST='vag-node7', PORT=7002);
create node pg_cd8 with(TYPE=coordinator, HOST='vag-node8', PORT=7002);
create node pg_cd10 with(TYPE=coordinator, HOST='vag-node10', PORT=7002);
create node pg_cd11 with(TYPE=coordinator, HOST='vag-node11', PORT=7002);
create node pg_cd12 with(TYPE=coordinator, HOST='vag-node12', PORT=7002);

create node pg_dn7 with(TYPE=datanode, HOST='vag-node7', PORT=7000, primary=false);
create node pg_dn8 with(TYPE=datanode, HOST='vag-node8', PORT=7000, primary=false);
create node pg_dn10 with(TYPE=datanode, HOST='vag-node10', PORT=7000, primary=false);
create node pg_dn11 with(TYPE=datanode, HOST='vag-node11', PORT=7000, primary=false);
create node pg_dn12 with(TYPE=datanode, HOST='vag-node12', PORT=7000, primary=false);

alter node pg_dn11 with(TYPE=datanode, HOST='vag-node11', PORT=7000, primary=true);

create node group gp7 with(pg_dn7);
create node group gp8 with(pg_dn8);
create node group gp10 with(pg_dn10);
create node group gp11 with(pg_dn11);
create node group gp12 with(pg_dn12);

select pgxc_pool_reload();
select * from pgxc_node;
