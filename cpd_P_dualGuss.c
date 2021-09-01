#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "mex.h"
#define	max(A, B)	((A) > (B) ? (A) : (B))
#define	min(A, B)	((A) < (B) ? (A) : (B))

void cpd_comp(
		double* x,
		double* y, 
		double* newx,
		double* newy,
		double* sift,
        double* sigma2,
		double* outlier,
        double* P1,
        double* Pt1,
        double* Px,
    	double* E,
		double* P_out,
        int N,
		int M,
        int D
        )

{
  int		n, m, d;
  double	ksig, diff, razn, outlier_tmp, sp;
  double	*P, *temp_x;
  
  P = (double*) calloc(M, sizeof(double));
  temp_x = (double*) calloc(D, sizeof(double));
  
  ksig = -2.0 * *sigma2;
  outlier_tmp=(*outlier*M*pow (-ksig*3.14159265358979,0.5*D))/((1-*outlier)*N); 
 /* printf ("ksig = %lf\n", *sigma2);*/
  /* outlier_tmp=*outlier*N/(1- *outlier)/M*(-ksig*3.14159265358979); */
  
  
  for (n=0; n < N; n++) {
      
      sp=0;
      for (m=0; m < M; m++) {
          razn=0;
          for (d=0; d < D; d++) {
             //diff=*(x+n+d*N)-*(y+m+d*M);  diff=diff*diff;
			 diff =*(newx+n+d*N)-*(newy+m+d*M);  diff=diff*diff;
             razn+=diff* *(sift+m+n*M);
          }
          
          *(P+m)=exp(razn/ksig);
          sp+=*(P+m);
      }
      
      sp+=outlier_tmp;

	  /*=========================================*/ //This is useless. Ignore it.
	  for (m = 0; m < M; m++){
		  *(P_out + n*M + m) = *(P + m) / sp;
	  }
	  /*=========================================*/

      *(Pt1+n)=1-outlier_tmp/ sp;
      
      for (d=0; d < D; d++) {
       *(temp_x+d)=*(x+n+d*N)/ sp;
      }
         
      for (m=0; m < M; m++) {
         
          *(P1+m)+=*(P+m)/ sp;
          
          for (d=0; d < D; d++) {
          *(Px+m+d*N)+= *(temp_x+d)**(P+m);
          }
          
      }
      
   *E +=  -log(sp);     
  }
  *E +=D*N*log(*sigma2)/2;
    
  
  free((void*)P);
  free((void*)temp_x);

  return;
}

/* Input arguments */
#define IN_x		prhs[0]
#define IN_y		prhs[1]
#define IN_newx		prhs[2]
#define IN_newy		prhs[3]
#define IN_sift		prhs[4]
#define IN_sigma2	prhs[5]
#define IN_outlier	prhs[6]

/* Output arguments */
#define OUT_P1		plhs[0]
#define OUT_Pt1		plhs[1]
#define OUT_Px		plhs[2]
#define OUT_E		plhs[3]
#define OUT_P_out		plhs[4]


/* Gateway routine*/
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
	double *x, *y, *newx, *newy , *sift, *sigma2, *outlier, *P1, *Pt1, *Px, *E, *P_out;
  int     N, M, D;
  
  /* Get the sizes of each input argument */
  N = mxGetM(IN_x);
  M = mxGetM(IN_y);
  D = mxGetN(IN_x);
  
  /* Create the new arrays and set the output pointers to them */
  OUT_P1     = mxCreateDoubleMatrix(M, 1, mxREAL);
  OUT_Pt1    = mxCreateDoubleMatrix(N, 1, mxREAL);
  OUT_Px    = mxCreateDoubleMatrix(M, D, mxREAL);
  OUT_E       = mxCreateDoubleMatrix(1, 1, mxREAL);
  OUT_P_out = mxCreateDoubleMatrix(N, M, mxREAL);

    /* Assign pointers to the input arguments  */
  x      = mxGetPr(IN_x);
  y       = mxGetPr(IN_y);
  newx = mxGetPr(IN_newx);
  newy = mxGetPr(IN_newy);
  sift = mxGetPr(IN_sift); 
  sigma2       = mxGetPr(IN_sigma2);
  outlier    = mxGetPr(IN_outlier);

 
  
  /* Assign pointers to the output arguments */
  P1      = mxGetPr(OUT_P1);
  Pt1      = mxGetPr(OUT_Pt1);
  Px      = mxGetPr(OUT_Px);
  E     = mxGetPr(OUT_E);
  P_out = mxGetPr(OUT_P_out);


  /* Do the actual computations in a subroutine */
  cpd_comp(x, y, newx, newy, sift, sigma2, outlier, P1, Pt1, Px, E, P_out, N, M, D);
  
  return;
}


