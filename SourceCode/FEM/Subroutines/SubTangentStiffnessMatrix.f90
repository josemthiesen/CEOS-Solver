!##################################################################################################
! This routine calculates the global tangent stiffness matrix.
!--------------------------------------------------------------------------------------------------
! Date: 2014/02
!
! Authors:  Jan-Michel Farias
!           Thiago Andre Carniel
!           Paulo Bastos de Castro
!!------------------------------------------------------------------------------------------------
! Modifications:
! Date: 2017        Author: Bruno Klahr
!##################################################################################################

subroutine TangentStiffnessMatrix( AnalysisSettings , ElementList , nDOF, Kg )

    !************************************************************************************
    ! DECLARATIONS OF VARIABLES
    !************************************************************************************
    ! Modules and implicit declarations
    ! -----------------------------------------------------------------------------------
    use ModAnalysis
    use ModElementLibrary
    use ModInterfaces
    use ModGlobalSparseMatrix
    use ModTimer

    implicit none

    ! Input variables
    ! -----------------------------------------------------------------------------------
    type(ClassAnalysis)                       , intent(inout) :: AnalysisSettings
    type(ClassElementsWrapper) , dimension(:) , intent(in)    :: ElementList
    type(ClassGlobalSparseMatrix)             , intent(in)    :: Kg
    integer                                                   :: nDOF

    ! Internal variables
    ! -----------------------------------------------------------------------------------
    integer :: i, e , nDOFel
    integer , pointer , dimension(:)   :: GM
    real(8) , pointer , dimension(:,:) :: Ke
    real(8) , pointer , dimension(:,:) :: Kte
    real(8) , pointer , dimension(:,:) :: Ge
    real(8) , pointer , dimension(:,:) :: Ne
    type(ClassTimer)                   :: Tempo
    
 
    !************************************************************************************
    ! GLOBAL TANGENT STIFFNESS MATRIX
    !************************************************************************************
    Kg%Val = 0.0d0

    ! Assemble Tangent Stiffness Matrix - Multiscale Taylor and Linear
    !---------------------------------------------------------------------------------
    !$OMP PARALLEL DEFAULT(PRIVATE) SHARED(Kg, ElementList, AnalysisSettings)
    !$OMP DO
    do  e = 1, size( ElementList )

        call ElementList(e)%El%GetElementNumberDOF( AnalysisSettings , nDOFel )

        Ke => Ke_Memory( 1:nDOFel , 1:nDOFel )
        GM => GM_Memory( 1:nDOFel )

        call ElementList(e)%El%GetGlobalMapping( AnalysisSettings, GM )

        call ElementList(e)%El%ElementStiffnessMatrix( Ke, AnalysisSettings )
                
        !$OMP CRITICAL
        !call AssembleGlobalMatrix( GM, Ke, Kg )
        call AssembleGlobalMatrixUpperTriangular( GM, Ke, Kg )
        !$OMP END CRITICAL

    enddo
    !$OMP END DO
    !$OMP END PARALLEL
    !---------------------------------------------------------------------------------
    

end subroutine
