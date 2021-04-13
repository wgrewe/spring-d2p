set Item;
set feats;

param Group_1_1{Item}>=0;
param Group_1_2{Item}>=0;
param Group_1_3{Item}>=0;
param Group_2_1{Item}>=0;
param Group_2_2{Item}>=0;
param Group_2_3{Item}>=0;
param Group_2_4{Item}>=0;
param Group_3_1{Item}>=0;
param Group_3_2{Item}>=0;
param Group_3_3{Item}>=0;
param Result{Item}>=-1;

set pos_I;
set pos_b;
set neg_I;
set neg_b;


set POS_SCHOOL;
set NEG_SCHOOL;
set BRANCH_NODES;
set POS_LEAF_NODES;
set NEG_LEAF_NODES;

param N > 0; #number of samples
param B > 0; #number of leaf nodes
param F > 0; #number of features
param K > 0; #number of branch nodes
param C > 0; #weight to account for imbalance
param G > 0;
param a{0..F, 0..N}>= 0;
# maybe param a, maybe read in data

var c_pos{i in POS_LEAF_NODES, j in POS_SCHOOL} >= 0;
var c_neg{i in NEG_LEAF_NODES, j in NEG_SCHOOL} >= 0;
var v{k in feats, j in 0..G, i in BRANCH_NODES} >= 0;
var z{0..F, i in BRANCH_NODES} >= 0; 

maximize Correct_Classification:
sum{i1 in POS_LEAF_NODES, j1 in POS_SCHOOL} c_pos[i1, j1] 
+ C*sum{i2 in NEG_LEAF_NODES, j2 in NEG_SCHOOL} c_neg[i2, j2];

subject to 1_branch_feature {i in 0..K}:
sum {t in 0..G}sum {s in feats} v[t,s,i] = 1;

subject to feature_in_group {i in 0..F, j in BRANCH_NODES, k in feats, h in 0..G}:
z[i,j] <= v[k,h,j];

subject to left_split {i in 0..N, b in 0..B, k in BRANCH_NODES}:
c_pos[b, i] <= sum{j in 0..F} a[j, i]*z[j, k];
#need to account for Left splits

subject to right_split {i in 0..N, b in 0..B, k in BRANCH_NODES}:
c_neg[b, i] <= 1 - (sum{j in 0..F} a[j, i]*z[j, k]);
#need to account for Right splits


#subject to 1_assigned_node {i in 0..N}:
#sum {b in 0..B} c[b, i] = 1;