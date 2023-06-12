!--------------------------------------------------------------------------------------------------
! Date: 2023/01
!
! Author:  José Luís M. Thiesen
!
!------------------------------------------------------------------------------------------------
!##################################################################################################
module ModKrylovSolver

	!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	! DECLARATIONS OF VARIABLES
	!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	! Modules and implicit declarations
	! ---------------------------------------------------------------------------------------------
    use ModLinearSolver

    private::ErrorDesc

	!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

	!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    ! ClassKrylovSolver: Attributes and methods of the KRYLOV Solver
	!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    
    type, extends(ClassLinearSolver) :: ClassKrylovSolver

		! Class Attributes
		!----------------------------------------------------------------------------------------

        integer ::  n

        contains
            ! Class Methods
            !----------------------------------------------------------------------------------
            procedure :: SolveSparse => KrylovSolve
            procedure :: ReadSolverParameters => KrylovReadParameters
            procedure :: Constructor => KrylovConstructor
            procedure :: Destructor  => KrylovDestructor

    end type
	!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

    contains
        !==========================================================================================
        ! Method KrylovConstructor: Routine that constructs the Krylov Solver
        !------------------------------------------------------------------------------------------
        ! Modifications:
        ! Date:         Author:
        !==========================================================================================
        subroutine KrylovConstructor(this , n)

		    !************************************************************************************
            ! DECLARATIONS OF VARIABLES
		    !************************************************************************************
            ! Modules and implicit declarations
            ! -----------------------------------------------------------------------------------
            implicit none

            ! Object
            ! -----------------------------------------------------------------------------------
            class(ClassKrylovSolver)::this

            ! Input variables
            ! -----------------------------------------------------------------------------------
            integer :: n

		    !************************************************************************************

 		    !************************************************************************************
            ! SET KRYLOV INPUT PARAMETERS
		    !************************************************************************************

            call this%Destructor ()

            ! Number of equations in the sparse linear systems of equations A*X = B
            this%n = n

		    !************************************************************************************

        end subroutine
        !==========================================================================================


        !==========================================================================================
        ! KrylovDestructor: Routine that destructs the Krylov vectors
        !------------------------------------------------------------------------------------------
        ! Modifications:
        ! Date:         Author:
        !==========================================================================================
        subroutine KrylovDestructor(this)

		    !************************************************************************************
            ! DECLARATIONS OF VARIABLES
		    !************************************************************************************
            ! Object
            ! -----------------------------------------------------------------------------------
            class(ClassKrylovSolver) :: this

		    !************************************************************************************

		    !************************************************************************************

        end subroutine
        !==========================================================================================


        !==========================================================================================
        ! KRYLOVSolve: Routine that solves the linear system and release memory in the Krylov
        !------------------------------------------------------------------------------------------
        ! Modifications:
        ! Date:         Author:
        !==========================================================================================
        subroutine KrylovSolve( this, A , b, x )
        
            use ModGlobalSparseMatrix
            use ModGMRES
            
		    !************************************************************************************
            ! DECLARATIONS OF VARIABLES
		    !************************************************************************************
            ! Object
            ! -----------------------------------------------------------------------------------
            class(ClassKrylovSolver) :: this
            
            ! Input variables
            ! -----------------------------------------------------------------------------------
            real(8) , dimension(:) ::  b
            type(ClassGlobalSparseMatrix) :: A

            ! Input/Output variables
            ! -----------------------------------------------------------------------------------
            real(8) , dimension(:) :: x

		    !************************************************************************************

 		    !************************************************************************************
            ! SOLVING THE LINEAR SYSTEM AND RELEASE MEMORY
		    !************************************************************************************
            
            call this%Constructor ( size(x) )
            
            x = 0.0d+0
            
            !call CallPardiso( this, PhaseAll, A%val, A%RowMap, A%Col, b, x )
            
            !! pmgmres_ilu_cr() applies the preconditioned restarted GMRES algorithm.
            !subroutine pmgmres_ilu_cr ( n, nz_num, ia, ja, a, x, rhs, itr_max, mr, &
            !                            tol_abs, tol_rel )
            call pmgmres_ilu_cr (size(x), size(A%val), A%RowMap, A%Col, A%val, x, b, 15, 15, & 
                                       1.0d-3, 1.0d-3)


            call this%Destructor ()
            
		    !************************************************************************************

        end subroutine
        !==========================================================================================


        subroutine KrylovReadParameters(this,DataFile)
            use ModParser
            class(ClassKrylovSolver)::this
            class(ClassParser) :: DataFile
            !Does nothing
        end subroutine

end module
