!##################################################################################################
! This module has the attributes and methods to select the parameters of the analysis type choosen.
!--------------------------------------------------------------------------------------------------
! Date: 2014/02
!
! Authors:  Jan-Michel Farias
!           Thiago Andre Carniel
!           Paulo Bastos de Castro
!!------------------------------------------------------------------------------------------------
! Modifications:
! Date: 2019/05 (Biphasic Analysis)         Author: Bruno Klahr - Thiago A. Carniel
!##################################################################################################
module ModAnalysis
	!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	! DECLARATIONS OF VARIABLES
	!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    ! IDs of the analysis settings.
    !----------------------------------------------------------------------------------------------

    ! Enumerators
    !----------------------------------------------------------------------------------------------

    !Problem Type
    type ClassProblemTypes
        integer  :: Mechanical=1 , Thermal=2 , Biphasic = 3
    end type
    type (ClassProblemTypes), parameter :: ProblemTypes = ClassProblemTypes()


    !Analysis Type
    type ClassAnalysisTypes
        integer  :: Quasi_Static=1 , Transient=2
    end type
    type (ClassAnalysisTypes), parameter :: AnalysisTypes = ClassAnalysisTypes()


    !Hypothesis of Analysis
    type ClassHypothesisOfAnalysis
        integer :: PlaneStress=1 , PlaneStrain=2 , Axisymmetric=3 , ThreeDimensional=4
    end type
    type (ClassHypothesisOfAnalysis), parameter :: HypothesisOfAnalysis = ClassHypothesisOfAnalysis()


    !Element Technology
    type ClassElementTechnologies
        integer :: Full_Integration=1, Mean_Dilatation=2
    end type
    type (ClassElementTechnologies), parameter :: ElementTechnologies = ClassElementTechnologies()

    
    !Multiscale Models
    type ClassMultiscaleModels
        integer  :: Taylor=1 , Linear=2 , Periodic=3, Minimal=4, MinimalLinearD1 = 5, MinimalLinearD3 = 6, LinearMinimalP = 7, SecondOrderMinimal = 8
    end type
    type (ClassMultiscaleModels), parameter :: MultiscaleModels = ClassMultiscaleModels()
    
    !Splitting Algorithms
    type :: ClassSplittingScheme
    	integer ::  Drained = 1, Undrained = 2, FixedStress = 3, FixedStrain = 4 
    end type ClassSplittingScheme
    type (ClassSplittingScheme), parameter :: SplittingScheme = ClassSplittingScheme() 
    
    type :: ClassSolutionScheme
    	integer ::  Monolithic = 1, Sequential = 2
    end type ClassSolutionScheme
    type(ClassSolutionScheme), parameter :: SolutionScheme = ClassSolutionScheme()
    
    !Staggered Parameters
    type :: ClassStaggeredParameters
    	real(8) :: SolidStaggTol   
        real(8) :: FluidStaggTol   
        real(8) :: StabilityConst
        real(8) :: FixedStressNorm = 1.0d-15
        integer :: UndrainedActivator
        integer :: FixedStressActivator
    end type ClassStaggeredParameters
    
    
    
    ! Parameters of the analysis type.
    !----------------------------------------------------------------------------------------------
    integer , parameter :: MaxElementNumberDOF=200 , MaxTensorComponents=6, MaxElementNodes=100

    ! Arrays used to allocate memory
    !----------------------------------------------------------------------------------------------
    real(8) , target , dimension( MaxElementNumberDOF , MaxElementNumberDOF)    :: Ke_Memory
    real(8) , target , dimension( MaxElementNumberDOF , MaxElementNumberDOF)    :: Kuu_Memory
    real(8) , target , dimension( MaxElementNumberDOF , MaxElementNumberDOF)    :: Kup_Memory
    real(8) , target , dimension( MaxElementNumberDOF , MaxElementNumberDOF)    :: Kpu_Memory
    real(8) , target , dimension( MaxElementNumberDOF , MaxElementNumberDOF)    :: Kpp_Memory
    real(8) , target , dimension( MaxTensorComponents , MaxElementNumberDOF)    :: B_Memory
    real(8) , target , dimension( 9 , MaxElementNumberDOF)                      :: G_Memory
    real(8) , target , dimension( 9 , 9)                                        :: S_Memory
    real(8) , target , dimension( MaxTensorComponents , MaxTensorComponents)    :: D_Memory
    real(8) , target , dimension( MaxTensorComponents , MaxTensorComponents)    :: DP_Memory
    real(8) , target , dimension( MaxElementNumberDOF )                         :: SF_Memory
    real(8) , target , dimension( MaxElementNumberDOF )                         :: Fe_Memory
    real(8) , target , dimension( MaxTensorComponents )                         :: Stress_Memory
    real(8) , target , dimension( MaxElementNumberDOF , MaxElementNumberDOF)    :: DifSF_Memory
    integer , target , dimension( MaxElementNumberDOF )                         :: GM_Memory
    integer , target , dimension( MaxElementNumberDOF )                         :: GM_Monolithic_Memory
    
    
    real(8) , target , dimension( 9 , MaxElementNumberDOF)                      :: Q_Memory
    real(8) , target , dimension( 9, 9)                                         :: L_Memory    ! Monolithic Q,L,A Finite Element Matrices
    real(8) , target , dimension( 6, 3)                                         :: T_Memory
    real(8) , target , dimension( 9, 9)                                         :: A_Memory
    
    real(8) , target , dimension( MaxElementNumberDOF , 9)                      :: Nf_Q_vse_Memory
    real(8) , target , dimension( MaxElementNumberDOF , MaxElementNumberDOF)    :: Nfbs_Memory
    real(8) , target , dimension( MaxElementNumberDOF , 6)                      :: transHtransT_Memory
    real(8) , target , dimension( 6 , 6)                                        :: Kftg_Memory
    real(8) , target , dimension( MaxElementNumberDOF , 6)                      :: transHtransTKftg_Memory
    

    real(8) , target , dimension( MaxTensorComponents , MaxElementNumberDOF)    :: DB_Memory
    real(8) , target , dimension( MaxTensorComponents , MaxElementNumberDOF)    :: DPB_Memory
    real(8) , target , dimension( 9 , MaxElementNumberDOF)                      :: SG_Memory
    real(8) , target , dimension( 1, MaxElementNumberDOF )                      :: Bdiv_Memory
    
    
    real(8) , target , dimension( MaxElementNumberDOF , MaxElementNumberDOF)    :: Kte_Memory       ! Multiscale Minimal Variables
    real(8) , target , dimension( 9 , MaxElementNumberDOF)                      :: Ge_Memory
    real(8) , target , dimension( 3 , MaxElementNumberDOF)                      :: Ne_Memory
    real(8) , target , dimension( 9 , MaxElementNumberDOF)                      :: Gpg_Memory
    real(8) , target , dimension( 3 , MaxElementNumberDOF)                      :: Npg_Memory
    real(8) , target , dimension( MaxElementNumberDOF)                          :: Nfpg_Memory
    real(8) , target , dimension( 3 , MaxElementNumberDOF)                      :: Hfpg_Memory
    real(8) , target , dimension( 3 , MaxElementNumberDOF)                      :: Hfe_Memory
    real(8) , target , dimension( MaxElementNumberDOF)                          :: Nfe_Memory
    real(8) , target , dimension( 8 , MaxElementNumberDOF)                      :: transHYJS_Memory
    real(8) , target , dimension( 8 , MaxElementNumberDOF)                      :: transHYJS_e_Memory
    real(8) , target , dimension( 9 , MaxElementNumberDOF)                      :: HYJS_e_Memory

    
    
    real(8) , target , dimension( MaxElementNumberDOF , MaxElementNumberDOF)    :: KeF_Memory       ! Memory for Ke Fluid
    real(8) , target , dimension( MaxElementNumberDOF)                          :: Nf_Memory        ! Fluid functions
    real(8) , target , dimension( MaxElementNumberDOF, MaxElementNumberDOF)     :: N_Memory         ! Fluid functions (matrix format)
    real(8) , target , dimension( MaxElementNumberDOF)                          :: hs_Memory        ! Vector h (tr(e) = h^Tq)
    real(8) , target , dimension( MaxElementNumberDOF,1)                        :: bs_Memory        ! Vector bs (div(u) = b^Tq)
    real(8) , target , dimension( 3 , MaxElementNumberDOF)                      :: H_Memory         ! Matrix H (grad p = H p)
    real(8) , target , dimension( MaxTensorComponents,MaxTensorComponents)      :: Kf_Memory        ! Stiffeness matrix Kf
    real(8) , target , dimension( MaxElementNumberDOF )                         :: Pe_Memory        ! Vector P element
    real(8) , target , dimension( MaxElementNumberDOF )                         :: Pe_converged_Memory        ! Vector P converged 
    real(8) , target , dimension( MaxElementNumberDOF )                         :: Vse_Memory       ! Vector solid velocity element
    integer , target , dimension( MaxElementNumberDOF )                         :: GMfluid_Memory   ! Global Maping Fluid
    real(8) , target , dimension( 9 , MaxElementNumberDOF)                      :: SfG_Memory       ! Cauchy for fluid


	!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    ! Marking global variables as THREADPRIVATE so that they won't be shared between OMP regions
    !$OMP THREADPRIVATE(Ke_Memory)
    !$OMP THREADPRIVATE(Kuu_Memory)
    !$OMP THREADPRIVATE(Kup_Memory)
    !$OMP THREADPRIVATE(Kpu_Memory)
    !$OMP THREADPRIVATE(Kpp_Memory)
    !$OMP THREADPRIVATE(B_Memory)
    !$OMP THREADPRIVATE(G_Memory)
    !$OMP THREADPRIVATE(S_Memory)
    !$OMP THREADPRIVATE(D_Memory)
    !$OMP THREADPRIVATE(DP_Memory)
    !$OMP THREADPRIVATE(SF_Memory)
    !$OMP THREADPRIVATE(Fe_Memory)
    !$OMP THREADPRIVATE(Stress_Memory)
    !$OMP THREADPRIVATE(DifSF_Memory)
    !$OMP THREADPRIVATE(GM_Memory)
    !$OMP THREADPRIVATE(DB_Memory)
    !$OMP THREADPRIVATE(DPB_Memory)
    !$OMP THREADPRIVATE(SG_Memory)
    !$OMP THREADPRIVATE(Bdiv_Memory)
    
    !$OMP THREADPRIVATE(Kte_Memory)
    !$OMP THREADPRIVATE(Ge_Memory)
    !$OMP THREADPRIVATE(Ne_Memory)
    !$OMP THREADPRIVATE(Gpg_Memory)
    !$OMP THREADPRIVATE(Npg_Memory)
    !$OMP THREADPRIVATE(Nfpg_Memory) 
    !$OMP THREADPRIVATE(Hfpg_Memory) 
    !$OMP THREADPRIVATE(Hfe_Memory)
    !$OMP THREADPRIVATE(transHYJS_Memory)
    !$OMP THREADPRIVATE(transHYJS_e_Memory)
    !$OMP THREADPRIVATE(HYJS_e_Memory)
    !$OMP THREADPRIVATE(Nfe_Memory)
    !$OMP THREADPRIVATE(KeF_Memory)
    !$OMP THREADPRIVATE(Nf_Memory)
    !$OMP THREADPRIVATE(N_Memory)
    !$OMP THREADPRIVATE(hs_Memory)
    !$OMP THREADPRIVATE(bs_Memory)
    !$OMP THREADPRIVATE(H_Memory)
    !$OMP THREADPRIVATE(Kf_Memory)
    !$OMP THREADPRIVATE(Pe_Memory)
    !$OMP THREADPRIVATE(Pe_converged_Memory)
    !$OMP THREADPRIVATE(VSe_Memory)
    !$OMP THREADPRIVATE(GMfluid_Memory)
    !$OMP THREADPRIVATE(SfG_Memory)
    
    
    !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    ! ClassAnalysis: Definitions of the analysis type
	!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    type ClassAnalysis

		! Class Attributes
		!----------------------------------------------------------------------------------------
        integer ::  ProblemType
        integer ::  AnalysisType
        integer ::  Hypothesis
        integer ::  ElementTech
        integer ::  MultiscaleModel
        integer ::  FiberAxialDirection
        integer ::  MultiscaleModelFluid
        integer ::  SplittingScheme
        integer ::  SolutionScheme
        logical ::  NLAnalysis
        logical ::  MultiscaleAnalysis
        logical ::  EmbeddedElements
        
        logical             :: FiberReinforcedAnalysis
        character(len=100)  :: FiberDataFileName

        integer ::  NDOFnode   , AnalysisDimension
        integer ::  BRowSize   , DSize
        integer ::  StressSize , StrainSize
        integer ::  GRowSize   , SSize 
        integer ::  NDOFsolid  , NDOFfluid
        integer ::  MaxCutBack
        
        integer ::  Pdof
        
        ! Referential volume
        real(8) :: TotalVolX = 0
        
        ! Moment of Volume J
        real(8), dimension(3,3) :: Volume_Moment_J
        
        ! Multiscale Minimal Model Parameter
        real(8) :: MultiscaleEpsilonParameter      
        
        ! Staggered Parameter
        type(ClassStaggeredParameters) :: StaggeredParameters
        
        contains

            ! Class Methods
            !----------------------------------------------------------------------------------
            procedure :: ClassAnalysisConstructor
            procedure :: GetTotalNumberOfDOF
            procedure :: GetTotalNumberOfDOF_fluid

    end type
	!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


    contains

        !==========================================================================================
        ! Method ClassAnalysisConstructor: Routine that constructs the analysis type
        !------------------------------------------------------------------------------------------
        ! Modifications:
        ! Date:         Author:
        !==========================================================================================
        subroutine  ClassAnalysisConstructor(this,FlagAnalysisSettings)
		    !************************************************************************************
            ! DECLARATIONS OF VARIABLES
		    !************************************************************************************
            ! Modules and implicit declarations
            ! -----------------------------------------------------------------------------------
            implicit none

            ! Object
            ! -----------------------------------------------------------------------------------
            class(ClassAnalysis) :: this

            ! Input variables
            ! -----------------------------------------------------------------------------------
            integer , intent(in) :: FlagAnalysisSettings
		    !************************************************************************************

 		    !************************************************************************************
            ! SELECT PARAMETERS OF THE ANALYSIS TYPE
		    !************************************************************************************

            this % Hypothesis = FlagAnalysisSettings

            select case (FlagAnalysisSettings)

                case (HypothesisOfAnalysis%PlaneStrain)
                    this % NDOFNode = 2
                    this % AnalysisDimension = 2
                    this % BRowSize = 3
                    this % GRowSize = 4
                    this % SSize = 4
                    this % DSize = 3
                    this % StressSize = 4
                    this % StrainSize = 3
                    this % Pdof = 1

                case (HypothesisOfAnalysis%PlaneStress)
                    this % NDOFNode = 2
                    this % AnalysisDimension = 2
                    this % BRowSize = 3
                    this % GRowSize = 4
                    this % SSize = 4
                    this % DSize = 3
                    this % StressSize = 3
                    this % StrainSize = 4
                    this % Pdof = 1

                case (HypothesisOfAnalysis%Axisymmetric)
                    this % NDOFNode = 2
                    this % AnalysisDimension = 2
                    this % BRowSize = 4
                    this % GRowSize = 5
                    this % SSize = 5
                    this % DSize = 4
                    this % StressSize = 4
                    this % StrainSize = 4
                    this % Pdof = 1

                case (HypothesisOfAnalysis%ThreeDimensional)
                    this % NDOFNode = 3
                    this % AnalysisDimension = 3
                    this % BRowSize = 6
                    this % GRowSize = 9
                    this % SSize = 9
                    this % DSize = 6
                    this % StressSize = 6
                    this % StrainSize = 6
                    this % Pdof = 1

                case default
                    stop "Error: analysis type not identified."

            end select

		    !************************************************************************************
        end subroutine
        !==========================================================================================

        !==========================================================================================
        ! Method GetTotalNumberOfDOF: Routine that
        !------------------------------------------------------------------------------------------
        ! Modifications:
        ! Date:         Author:
        !==========================================================================================
        subroutine  GetTotalNumberOfDOF(this, GlobalNodesList, TotalnDOF)
		    !************************************************************************************
            ! DECLARATIONS OF VARIABLES
		    !************************************************************************************
            ! Modules and implicit declarations
            ! -----------------------------------------------------------------------------------
            use ModNodes
            implicit none

            ! Object
            ! -----------------------------------------------------------------------------------
            class(ClassAnalysis) :: this

            ! Input variables
            ! -----------------------------------------------------------------------------------
            type (ClassNodes), dimension(:)  :: GlobalNodesList

            ! Output variables
            ! -----------------------------------------------------------------------------------
            integer :: TotalnDOF
		    !************************************************************************************

 		    !************************************************************************************
            ! TOTAL NUMBER OF DOF
		    !************************************************************************************

            TotalnDOF = size( GlobalNodesList ) * this%NDOFnode
            
            this%NDOFsolid = TotalnDOF 

		    !************************************************************************************

        end subroutine
        !==========================================================================================

        !==========================================================================================
        subroutine  GetTotalNumberOfDOF_fluid(this, GlobalNodesList, TotalnDOF_fluid)
		    !************************************************************************************
            ! DECLARATIONS OF VARIABLES
		    !************************************************************************************
            ! Modules and implicit declarations
            ! -----------------------------------------------------------------------------------
            use ModNodes
            implicit none

            ! Object
            ! -----------------------------------------------------------------------------------
            class(ClassAnalysis) :: this

            ! Input variables
            ! -----------------------------------------------------------------------------------
            type (ClassNodes), dimension(:)  :: GlobalNodesList

            ! Output variables
            ! -----------------------------------------------------------------------------------
            integer :: TotalnDOF_fluid, nNosFluid
            integer :: i
		    !************************************************************************************

 		    !************************************************************************************
            ! TOTAL NUMBER OF DOF OF FLUID
		    !************************************************************************************
            nNosFluid = 0.0d0
            do i=1, size(GlobalNodesList)
                if (GlobalNodesList(i)%IDFluid .ne. 0) then
                    nNosFluid = nNosFluid + 1
                endif
            enddo
            
            TotalnDOF_fluid = nNosFluid * this % Pdof 
            
            this%NDOFfluid = TotalnDOF_fluid

		    !************************************************************************************

        end subroutine
        !==========================================================================================

end module

