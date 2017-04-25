function [] = main_fun( soln, mats, parms )

addpath(genpath('./build_mats/'))
addpath('./runtime_operators/')
addpath('./body_gen/')


%--Double-check that m and n were specified correctly
    if ( mod(parms.m, 4) ~=0 | mod(parms.n, 4) ~= 0 )
        error( 'Error: parms.m and parms.n must be divisible by 4')
    end

%--

%---Get body

    if parms.it_start == 0
        [parms, soln] = get_body( parms );
    end
%---
    
%---preprocessing: 

    if isempty( mats )
        tic
        %build and store matrices using sparse operations
        display('------------------------------------------------------------')
        display('Pre-processing stage: building and storing matrices for run')
        [mats, parms] = get_mats_preproc( parms, soln );

        pre_time = toc;

        display('Done building and storing matrices')
        display(['Spent ',num2str(pre_time),' secs on pre-processing.']) 
        display('------------------------------------------------------------')
    end
%---
    

%---advance in time

    for it = parms.it_start : parms.it_stop
        
        %output occasionally to tell us we're advancing in time
        if mod( it, 1 ) == 0 & it > 0
            display( ['Advancing to time step ', num2str( it+1 )] )
            display( ['cfl = ', num2str( soln.cfl(it) )] )
            if parms.deform == 'T'
                display( ['Tip displacement = ', num2str( soln.tip_disp( it ) ) ] )
            end
        end
       
        %advance a time step and return circulation (gamma), vel flux (q), and 
        %surface stress (fb)
        [soln, parms, mats] = advance( it, parms, mats, soln );
        
        
        %save other variables if at a save point
        if ( ( mod( it, parms.it_save ) == 0 ) | ( it == parms.it_stop ) )

            save(['outputs/runvars_it_',num2str(it),'.mat'], ...
                'soln', 'parms' );
        end
        
    end
    
%---





