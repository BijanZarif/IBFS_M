function I_til_s2vort = get_I_til_s2vort( grid_parms )

%get a diagonal matrix of size ngamma x ngamma, where ngamma is the number
%of vorticity points on the domain. I_til = 1 everywhere except at the
%outflow boundary, where it is = 0.

%Inputs: grid_parms -- data structure containing m (number of points in x
%dirn), n (number of points in y dirn), mg (number of grid levels), and len
%(length of domain in x-dirn ==> dx = len / m )

m = grid_parms.m; n = grid_parms.n; mg = grid_parms.mg;

%Get size of I_til
nrows = get_vort_ind( m, n-1, mg, grid_parms );
ncols = nrows ;

I_til_s2vort = sparse( nrows, ncols );


%entries at outflow boundary:
ind = get_vort_ind(m,1:n-1,mg,grid_parms);
I_til_s2vort = I_til_s2vort + sparse( ind,ind, ones(size(ind)),...
    nrows, ncols );

indl = get_vort_ind(m-1,1:n-1,mg,grid_parms);
I_til_s2vort = I_til_s2vort - sparse( ind,indl, ones(size(ind)), ...
    nrows, ncols );







