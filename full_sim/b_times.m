function x = b_times( z, parms, mats )

%Performs one matrix multiply of B*z, where B is the matrix used to solve
%for the surface stresses that enforce the no-slip boundary condition.

% (B arises from an LU factorization of the full system)


%--Initialize

    m = parms.m; n = parms.n; mg = parms.mg;
    h = (parms.len / parms.m); ngam = (m-1)* (n-1);

    circ = zeros( (m-1)*(n-1), mg ); 
    
%--


%-- get circulation from surface stress

    %Get circ on 1st grid level
    circ(:, 1) = Ainv( mats.R * mats.ET * z, 1, parms, mats );
    %We don't include BCs from coarse grid for Ainv because ET*z is compact

    
    %Coarsify circulation to second grid level to get BCs for stfn
    if mg > 1
        circ(:,2) = coarsify( circ(:,1), circ(:,2), parms );
    end
    
%--

%--Solve Poisson problem for stfn

    %BCs for Poisson problem (will be overwritten if mg > 1)
    stbc.bott = zeros( ngam, 1 );
    stbc.top = stbc.bott; stbc.left = stbc.top; stbc.right = stbc.top;

    %If more than 1 grid then use 2nd grid for bcs
    if mg > 1

        %Solve on coarser grid level to get bcs for first grid level
        stfn = RCinv( circ(:,2), parms, mats );

        %Get bcs from this streamfunction on the 2nd gridlevel
        stbc = get_stfn_BCs( stbc, stfn, parms );
        
    end
        
    %Get on fine grid level
    stfn = RCinv( circ(:,1) + stbc.left + stbc.right + ...
        stbc.bott + stbc.top, parms, mats );
    
%--

%--Get velocity on first grid from stream function

    vflx = curl( stfn, stbc, parms, mats );

%--
    
    
%--Interpolate onto the body and scale by h
    
    x = mats.E * vflx / h;

%--




