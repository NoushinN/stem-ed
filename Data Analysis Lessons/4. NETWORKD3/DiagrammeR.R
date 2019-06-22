###DEMO for DiagrammeR###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

library(DiagrammeR)

grViz("
      digraph boxes_and_circles {
      
      # a 'graph' statement
      
      graph [layout = dot, overlap = true, fontsize = 10]
      
      # several 'node' statements       
      
      node [shape = box,
      fontname = Helvetica
      style = filled]
      
      node [fillcolor = Gold, shape = square]
      Pop_Table 
      
      node [fillcolor = LightBlue, shape = oval]
      Table1; Table2; Table3
      
      node [fillcolor = Lavender, shape = egg]
      Subtable1; Subtable2; Subtable3; Subtable4

      node [fillcolor = MediumTurquoise, shape = square]
      Data1; Data2; Data3
      
      node [fillcolor = Gainsboro, shape = square]
      Data4
      
      # several 'edge' statements
      
      edge [color = black]
      Data1 -> {Pop_Table}
      Data2 -> {Pop_Table}
      Data3 -> {Pop_Table}
      Data4 -> {Pop_Table}
      Subtable1 -> {Table1}
      Subtable2 -> {Table2} [ dir=forward, xlabel='merge'];
      Subtable3 -> {Table2} [ dir=forward, xlabel='merge'];
      Subtable4 -> {Table3}
      Table1 -> {Data1}
      Table2 -> {Data2}[ dir=forward, arrowhead = dot];
      Table3 -> {Data3}

      }")


#--------------------------------------------------------------------------      
# Overall worflow 

grViz("
      digraph nicegraph {
      # a 'graph' statement
      graph [overlap = true, fontsize = 14]
      node [shape = none,
      fontname = Helvetica,
      fontsize = 12]
      
      # graph, node, and edge definitions
      
      node [shape = box,
      fontname = Helvetica,
      style = filled,
      fillcolor = white]
      step0[label = 'PROJECT: X\\n (Working Folder)', group = g1, fillcolor = MistyRose, shape = oval];
      step1[label = 'PROJECT PHASE\\n (Prototype Phase)', group = g1, fillcolor = MistyRose, shape = oval];
      
      
      a0[label = 'Project\\l'];
      a1[label = 'Phase\\l'];
      
      
      a2[label = 'Data Tables\\l'];
      a3[label = 'Cleaning\\l - Filter\\l - Select\\l'];
      a4[label = 'Integration\\l - Joins\\l'];
      a5[label = '4 Cohorts\\n- X\\l - Y\\l - Z\\l - A\\l'];
      a6[label = 'Merge 4 cohorts\\l'];
      
      
      #SDPR
      subgraph cluster_1 {
      style = filled;
      color = DarkKhaki;
      step2[label = 'load_data\\n(X)\\l', group = g1];
      step3[label = 'transform_data\\l', group = g2]; 
      step4[label = 'merge_data\\l', group = g3];
      }
      
      
      #EDU
      subgraph cluster_2 {
      style = filled;
      color = DarkKhaki;
      step5[label = 'load_data\\n(Y)\\l', group = g1];
      step6[label = 'transform_data\\l', group = g2]; 
      step7[label = 'merge_data\\l', group = g3];
      }
      
      #PSSG
      subgraph cluster_3 {
      style = filled;
      color = DarkKhaki;
      step8[label = 'load_data\\n(Z)\\l', group = g1];
      step9[label = 'transform_data\\l', group = g2]; 
      }
      
      
      #MOH
      subgraph cluster_4 {
      style = filled;
      color = DarkKhaki;
      step10[label = 'load_data\\n(A)\\l', group = g1];
      step11[label = 'transform_data\\l', group = g2]; 
      step12[label = 'merge_data\\l', group = g3];
      }
      
      
      #output workflow 
      
      subgraph cluster_5 {
      style = filled;
      color = white;
      step13[label = 'output_tables', group = g4, fillcolor = MediumTurquoise, shape = square ];
      }
      
      subgraph cluster_6 {
      style = filled;
      color = white;
      step14[label = 'Study Population', group = g5, fillcolor = Gold, shape = square ];
      }
      
      # several 'edge' statements
      step0 -> step1
      step1 -> step2
      step1 -> step5
      step1 -> step8
      step1 -> step10
      step2 -> step3
      step3 -> step4
      step5 -> step6
      step6 -> step7
      step8 -> step9
      step10 -> step11
      step11 -> step12
      step4 -> step13
      step7 -> step13
      step9 -> step13
      step12 -> step13
      step13 -> step14
      
      edge[style=invis]
      
      a0 -> a1
      a1 -> a2
      a2 -> a3
      a2 -> a3
      a3 -> a4
      a4 -> a5
      a5 -> a6
      }
      ")
