# Fidelity Pointwise V18.6R4 Journal file - Thu Mar 14 10:30:22 2024

package require PWI_Glyph 7.22.2

pw::Application setUndoMaximumLevels 5

# Load Pointwise Glyph package and Tk
#package require PWI_Glyph 2.4
pw::Script loadTk
pw::Application reset


########################  INPUT  #######################

# Spacing normal to wall
set dsn        0.0000015

# Leading and trailing edge spacings
set dsle       0.001
set dste       0.0002

# Number of points in the chordwise direction for top and
# bottom surfaces each (Total will be double-ish)
set imax       141

# Number of points in spanwise direction
set kmax       10

# Inner block
set jmax       36
set growthfac  1.3
set kbasmoo    0.0
set expsmoo    0.5
set impsmoo    1.0
set volsmoo    0.1

# Outer block
set jmax2      100
set growthfac2 1.017
set kbasmoo2   0.0
set expsmoo2   1.0
set impsmoo2   1.0
set volsmoo2   1.0

########################  COORDS  #######################

set fname naca3.dat
pw::Database import $fname
    set imported 2       

######################  DONT TOUCH  #####################

set _DB(1) [pw::DatabaseEntity getByName curve-1]
set _TMP(split_params) [list]
lappend _TMP(split_params) 0
unset _TMP(split_params)
pw::Application markUndoLevel Split

set _TMP(PW_2) [pw::Connector createOnDatabase -parametricConnectors Aligned -merge 0 -reject _TMP(unused) [list $_DB(1)]]
unset _TMP(unused)
unset _TMP(PW_2)
pw::Application markUndoLevel {Connectors On DB Entities}

set _CN(1) [pw::GridEntity getByName con-1]
set _TMP(mode_1) [pw::Application begin Dimension]
$_TMP(mode_1) abort
unset _TMP(mode_1)
set _TMP(split_params) [list]
lappend _TMP(split_params) [$_CN(1) getParameter -closest [pw::Application getXYZ [list 0.5 0.0 $_DB(1)]]]
set _TMP(PW_2) [$_CN(1) split $_TMP(split_params)]
unset _TMP(PW_2)
unset _TMP(split_params)
pw::Application markUndoLevel Split

set _CN(2) [pw::GridEntity getByName con-1-split-1]
set _TMP(mode_1) [pw::Application begin Dimension]
  set _CN(3) [pw::GridEntity getByName con-1-split-2]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Dimension

set _TMP(PW_2) [pw::Collection create]
$_TMP(PW_2) set [list $_CN(2)]
$_TMP(PW_2) do setRenderAttribute PointMode All
$_TMP(PW_2) delete
unset _TMP(PW_2)
pw::Application markUndoLevel {Modify Entity Display}

set _TMP(PW_2) [pw::Collection create]
$_TMP(PW_2) set [list $_CN(2)]
$_TMP(PW_2) do setRenderAttribute PointMode All
$_TMP(PW_2) delete
unset _TMP(PW_2)
pw::Application markUndoLevel {Modify Entity Display}

set _TMP(mode_1) [pw::Application begin Dimension]
  set _TMP(PW_2) [pw::Collection create]
  $_TMP(PW_2) set [list $_CN(2)]
  $_TMP(PW_2) do setDimension -resetDistribution $imax
  $_TMP(PW_2) delete
  unset _TMP(PW_2)
  $_TMP(mode_1) balance -resetGeneralDistributions
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Dimension

set _TMP(mode_1) [pw::Application begin Dimension]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Dimension

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(2)]]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(2)]]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(2)]]
  #[[$_CN(2) getDistribution 1] getEndSpacing] setValue $initds
  $_CN(2) replaceDistribution 1 [pw::DistributionTanh create]
  [$_CN(2) getDistribution 1] setBeginSpacing 0.0
  [$_CN(2) getDistribution 1] setEndSpacing 0.0
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(2)]]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(2)]]
$_TMP(mode_1) abort
unset _TMP(mode_1)
$_CN(2) setDimensionFromSpacing -resetDistribution 0.001
pw::CutPlane refresh
pw::Application markUndoLevel Dimension

$_CN(2) setDimension $imax
pw::CutPlane refresh
pw::Application markUndoLevel Dimension

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(2)]]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(2)]]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(2)]]
  [[$_CN(2) getDistribution 1] getEndSpacing] setValue $dsle
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(2)]]
$_TMP(mode_1) abort
unset _TMP(mode_1)
pw::Entity delete [list $_CN(2)]
pw::Application markUndoLevel Delete

pw::Application undo
set _CN(4) [pw::GridEntity getByName con-1-split-1]
pw::Entity delete [list $_CN(4)]
pw::Application markUndoLevel Delete

pw::Entity delete [list $_CN(3)]
pw::Application markUndoLevel Delete

set _TMP(PW_2) [pw::Connector createOnDatabase -parametricConnectors Aligned -merge 0 -reject _TMP(unused) [list $_DB(1)]]
unset _TMP(unused)
unset _TMP(PW_2)
pw::Application markUndoLevel {Connectors On DB Entities}

set _CN(5) [pw::GridEntity getByName con-1]
set _TMP(split_params) [list]
lappend _TMP(split_params) 0
unset _TMP(split_params)
pw::Application markUndoLevel Split

set _TMP(split_params) [list]
lappend _TMP(split_params) [lindex [$_DB(1) closestPoint {4.33680868994202e-19 2.16840434497101e-19 0}] 0]
set _TMP(PW_3) [$_DB(1) split $_TMP(split_params)]
unset _TMP(PW_3)
unset _TMP(split_params)
pw::Application markUndoLevel Split

set _DB(2) [pw::DatabaseEntity getByName curve-1-split-1]
set _DB(3) [pw::DatabaseEntity getByName curve-1-split-2]
set _TMP(split_params) [list]
lappend _TMP(split_params) [$_CN(5) getParameter -closest [pw::Application getXYZ [list 1.0 0.0 $_DB(2)]]]
set _TMP(PW_3) [$_CN(5) split $_TMP(split_params)]
unset _TMP(PW_3)
unset _TMP(split_params)
pw::Application markUndoLevel Split

set _CN(6) [pw::GridEntity getByName con-1-split-1]
set _TMP(mode_1) [pw::Application begin Dimension]
  set _CN(7) [pw::GridEntity getByName con-1-split-2]
  set _TMP(PW_3) [pw::Collection create]
  $_TMP(PW_3) set [list $_CN(6)]
  $_TMP(PW_3) do setDimension -resetDistribution $imax
  $_TMP(PW_3) delete
  unset _TMP(PW_3)
  $_TMP(mode_1) balance -resetGeneralDistributions
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Dimension

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(6)]]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(6)]]
  [$_CN(6) getDistribution 1] reverse
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(6)]]
  [$_CN(6) getDistribution 1] reverse
  $_CN(6) setSubConnectorDimensionFromDistribution 1
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(6)]]
$_TMP(mode_1) abort
unset _TMP(mode_1)
pw::Entity delete [list $_CN(6)]
pw::Application markUndoLevel Delete

pw::Entity delete [list $_CN(7)]
pw::Application markUndoLevel Delete

set _TMP(PW_3) [pw::Connector createOnDatabase -parametricConnectors Aligned -merge 0 -reject _TMP(unused) [list $_DB(2)]]
unset _TMP(unused)
unset _TMP(PW_3)
pw::Application markUndoLevel {Connectors On DB Entities}

set _CN(8) [pw::GridEntity getByName con-1]
set _TMP(mode_1) [pw::Application begin Dimension]
  set _TMP(PW_3) [pw::Collection create]
  $_TMP(PW_3) set [list $_CN(8)]
  $_TMP(PW_3) do setDimension -resetDistribution $imax
  $_TMP(PW_3) delete
  unset _TMP(PW_3)
  $_TMP(mode_1) balance -resetGeneralDistributions
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Dimension

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(8)]]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(8)]]
$_TMP(mode_1) abort
unset _TMP(mode_1)
set _TMP(mode_1) [pw::Application begin Modify [list $_CN(8)]]
  pw::Connector swapDistribution Geometric [list [list $_CN(8) 1]]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(8)]]
  pw::Connector swapDistribution Tanh [list [list $_CN(8) 1]]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(8)]]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(8)]]
  [[$_CN(8) getDistribution 1] getEndSpacing] setValue $dsle
  [[$_CN(8) getDistribution 1] getBeginSpacing] setValue $dste
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(8)]]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(mode_1) [pw::Application begin Modify [list $_CN(8)]]
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Distribute

set _TMP(PW_3) [pw::Collection create]
$_TMP(PW_3) set [list $_CN(8)]
$_TMP(PW_3) do setRenderAttribute PointMode None
$_TMP(PW_3) delete
unset _TMP(PW_3)
pw::Application markUndoLevel {Modify Entity Display}

set _TMP(PW_3) [pw::Collection create]
$_TMP(PW_3) set [list $_CN(8)]
$_TMP(PW_3) do setRenderAttribute PointMode All
$_TMP(PW_3) delete
unset _TMP(PW_3)
pw::Application markUndoLevel {Modify Entity Display}

set _TMP(PW_3) [pw::Connector createOnDatabase -parametricConnectors Aligned -merge 0 -reject _TMP(unused) [list $_DB(3)]]
unset _TMP(unused)
unset _TMP(PW_3)
pw::Application markUndoLevel {Connectors On DB Entities}

set _CN(9) [pw::GridEntity getByName con-2]
set _TMP(mode_1) [pw::Application begin SpacingSync]
  set _TMP(PW_3) [pw::Connector synchronizeSpacings -minimum -growthRate 1.2 -returnDuplicates -undefined _TMP(undefinedDoms) [list $_CN(9) $_CN(8)]]
  unset _TMP(PW_3)
$_TMP(mode_1) abort
unset _TMP(mode_1)
set _TMP(PW_3) [pw::Collection create]
$_TMP(PW_3) set [list $_CN(9)]
$_TMP(PW_3) do setRenderAttribute PointMode None
$_TMP(PW_3) delete
unset _TMP(PW_3)
pw::Application markUndoLevel {Modify Entity Display}

set _TMP(PW_3) [pw::Collection create]
$_TMP(PW_3) set [list $_CN(9)]
$_TMP(PW_3) do setRenderAttribute PointMode All
$_TMP(PW_3) delete
unset _TMP(PW_3)
pw::Application markUndoLevel {Modify Entity Display}

set _TMP(mode_1) [pw::Application begin Dimension]
  set _TMP(PW_3) [pw::Collection create]
  $_TMP(PW_3) set [list $_CN(9)]
  $_TMP(PW_3) do setDimension -resetDistribution $imax
  $_TMP(PW_3) delete
  unset _TMP(PW_3)
  $_TMP(mode_1) balance -resetGeneralDistributions
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel Dimension

set _TMP(mode_1) [pw::Application begin SpacingSync]
  set _TMP(PW_3) [pw::Connector synchronizeSpacings -minimum -growthRate 1.2 -returnDuplicates -undefined _TMP(undefinedDoms) [list $_CN(9) $_CN(8)]]
  unset _TMP(PW_3)
$_TMP(mode_1) abort
unset _TMP(mode_1)
set _TMP(mode_1) [pw::Application begin SpacingSync]
  set _TMP(PW_3) [pw::Connector synchronizeSpacings -minimum -growthRate 1.2 -returnDuplicates -undefined _TMP(undefinedDoms) [list $_CN(9) $_CN(8)]]
  unset _TMP(PW_3)
$_TMP(mode_1) abort
unset _TMP(mode_1)
set _TMP(mode_1) [pw::Application begin SpacingSync]
  set _TMP(PW_3) [pw::Connector synchronizeSpacings -minimum -growthRate 1.2 -returnDuplicates -undefined _TMP(undefinedDoms) [list $_CN(9) $_CN(8)]]
  unset _TMP(PW_3)
$_TMP(mode_1) end
unset _TMP(mode_1)
pw::Application markUndoLevel {Sync Spacings}

set _TMP(mode_1) [pw::Application begin SpacingSync]
$_TMP(mode_1) abort
unset _TMP(mode_1)
set _TMP(PW_3) [pw::Connector join -reject _TMP(ignored) -keepDistribution [list $_CN(9) $_CN(8)]]
unset _TMP(ignored)
unset _TMP(PW_3)
set _TMP(PW_3) [pw::Curve join -reject _TMP(ignored) [list $_DB(3) $_DB(2)]]
unset _TMP(ignored)
unset _TMP(PW_3)
pw::Application markUndoLevel Join

set _TMP(mode_1) [pw::Application begin Create]
  set _CN(10) [pw::GridEntity getByName con-1]
  set _TMP(PW_3) [pw::Edge createFromConnectors [list $_CN(10)]]
  set _TMP(edge_1) [lindex $_TMP(PW_3) 0]
  unset _TMP(PW_3)
  set _DM(1) [pw::DomainStructured create]
  $_DM(1) addEdge $_TMP(edge_1)
$_TMP(mode_1) end
unset _TMP(mode_1)
set _TMP(mode_1) [pw::Application begin ExtrusionSolver [list $_DM(1)]]
  $_TMP(mode_1) setKeepFailingStep true
  $_DM(1) setExtrusionSolverAttribute NormalMarchingVector {-0 -0 -1}
  $_DM(1) setExtrusionSolverAttribute NormalInitialStepSize $dsn
  $_DM(1) setExtrusionSolverAttribute SpacingGrowthFactor $growthfac
  $_DM(1) setExtrusionSolverAttribute NormalKinseyBarthSmoothing $kbasmoo
  $_DM(1) setExtrusionSolverAttribute NormalExplicitSmoothing $expsmoo
  $_DM(1) setExtrusionSolverAttribute NormalImplicitSmoothing $impsmoo
  $_DM(1) setExtrusionSolverAttribute NormalVolumeSmoothing $volsmoo
  $_TMP(mode_1) run $jmax
  $_DM(1) setExtrusionSolverAttribute SpacingGrowthFactor $growthfac2
  $_DM(1) setExtrusionSolverAttribute NormalKinseyBarthSmoothing $kbasmoo2
  $_DM(1) setExtrusionSolverAttribute NormalExplicitSmoothing $expsmoo2
  $_DM(1) setExtrusionSolverAttribute NormalImplicitSmoothing $impsmoo2
  $_DM(1) setExtrusionSolverAttribute NormalVolumeSmoothing $volsmoo2
  $_TMP(mode_1) run $jmax2
$_TMP(mode_1) end
unset _TMP(mode_1)
unset _TMP(edge_1)
pw::Application markUndoLevel {Extrude, Normal}


set _CN(11) [pw::GridEntity getByName con-2]
pw::Entity delete [list $_CN(11)]
pw::Application markUndoLevel Delete

pw::Application undo
set _TMP(mode_1) [pw::Application begin Create]
  set _DM(1) [pw::GridEntity getByName dom-1]
  set _TMP(PW_3) [pw::FaceStructured createFromDomains [list $_DM(1)]]
  set _TMP(face_1) [lindex $_TMP(PW_3) 0]
  unset _TMP(PW_3)
  set _BL(1) [pw::BlockStructured create]
  $_BL(1) addFace $_TMP(face_1)
$_TMP(mode_1) end
unset _TMP(mode_1)
set _TMP(mode_1) [pw::Application begin ExtrusionSolver [list $_BL(1)]]
  $_TMP(mode_1) setKeepFailingStep true
  $_BL(1) setExtrusionSolverAttribute Mode Translate
  $_BL(1) setExtrusionSolverAttribute TranslateDirection {1 0 0}
  $_BL(1) setExtrusionSolverAttribute TranslateDirection {0 0 1}
  $_BL(1) setExtrusionSolverAttribute TranslateDistance 1
  $_TMP(mode_1) run $kmax
$_TMP(mode_1) end
unset _TMP(mode_1)
unset _TMP(face_1)
pw::Application markUndoLevel {Extrude, Translate}

pw::Display resetView -Y
pw::Display resetView -Z



set _TMP(PW_1) [pw::VolumeCondition create]
pw::Application markUndoLevel {Create VC}

$_TMP(PW_1) setPhysicalType Fluid
pw::Application markUndoLevel {Change VC Type}

unset _TMP(PW_1)
pw::Application markUndoLevel {Set Solver Attributes}

pw::Application setCAESolver {EXODUS II} 3
pw::Application markUndoLevel {Select Solver}

set _TMP(PW_1) [pw::VolumeCondition getByName vc-2]
$_TMP(PW_1) setName airfoil
pw::Application markUndoLevel {Name VC}

$_TMP(PW_1) apply [list $_BL(1)]
pw::Application markUndoLevel {Set VC}



set _TMP(PW_3) [pw::BoundaryCondition create]
pw::Application markUndoLevel {Create BC}

unset _TMP(PW_3)
set _TMP(PW_3) [pw::BoundaryCondition getByName bc-2]
$_TMP(PW_3) setName wall
$_TMP(PW_3) setPhysicalType -usage CAE {Side Set}
pw::Application markUndoLevel {Name BC}

set _DM(2) [pw::GridEntity getByName dom-2]
$_TMP(PW_3) apply [list [list $_BL(1) $_DM(2)]]
pw::Application markUndoLevel {Set BC}

set _TMP(PW_4) [pw::BoundaryCondition create]
pw::Application markUndoLevel {Create BC}

unset _TMP(PW_4)
set _TMP(PW_4) [pw::BoundaryCondition getByName bc-3]
$_TMP(PW_4) setName side1
$_TMP(PW_4) setPhysicalType -usage CAE {Side Set}
pw::Application markUndoLevel {Name BC}

set _DM(3) [pw::GridEntity getByName dom-6]
$_TMP(PW_4) apply [list [list $_BL(1) $_DM(3)]]
pw::Application markUndoLevel {Set BC}

set _TMP(PW_5) [pw::BoundaryCondition create]
pw::Application markUndoLevel {Create BC}

unset _TMP(PW_5)
set _TMP(PW_5) [pw::BoundaryCondition getByName bc-4]
$_TMP(PW_5) setName side2
$_TMP(PW_5) setPhysicalType -usage CAE {Side Set}
pw::Application markUndoLevel {Name BC}

$_TMP(PW_5) apply [list [list $_BL(1) $_DM(1)]]
pw::Application markUndoLevel {Set BC}

set _TMP(PW_6) [pw::BoundaryCondition create]
pw::Application markUndoLevel {Create BC}

unset _TMP(PW_6)
set _TMP(PW_6) [pw::BoundaryCondition getByName bc-5]
$_TMP(PW_6) setName outer
$_TMP(PW_6) setPhysicalType -usage CAE {Side Set}
pw::Application markUndoLevel {Name BC}

set _DM(4) [pw::GridEntity getByName dom-4]
$_TMP(PW_6) apply [list [list $_BL(1) $_DM(4)]]
pw::Application markUndoLevel {Set BC}

unset _TMP(PW_3)
unset _TMP(PW_4)
unset _TMP(PW_5)
unset _TMP(PW_6)


pw::Application save bla.pw
set _TMP(mode_1) [pw::Application begin CaeExport [pw::Entity sort [list $_BL(1)]]]
  $_TMP(mode_1) initialize -strict -type CAE bla.exo
  $_TMP(mode_1) verify
  $_TMP(mode_1) write
$_TMP(mode_1) end
unset _TMP(mode_1)     


pw::Application exit

# END SCRIPT       