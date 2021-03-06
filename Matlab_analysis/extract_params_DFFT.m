function [fmle,Vmle,CovMatmle,fmleError,VmleError]=extract_params_DFFT(str,plots)
%%'DFFT/Trial_Data/occ_f.mat'
%%%%%%%%%%
%%IN
%%-str: path to a .mat file that unpacks a structure array with a single
%%field. This field corresponds to a matrix of dimensions NbinsxTframes matrix with the number 
%of individuals observed in each bin at each timeframe

%%Extracts the frustration and vexation functions for a single dataset 

%%OUT
%%-fmle: a MaxPop+1(MaxPop is the maximum number of flies that were observed inside a bin) sized vector that corresponds to the frustration that came out of the MLE including the gauge fixed values (if gauge!=0 the average potential is set to zero and the gauge is adjusted for f(1) with appropiate error propagation)
%%-Vmle: a Nbins(number of bins in the system) sized vector that corresponds
%%to the vexation that came out of the MLE (if gauge!=0 the average potential is set to zero)
%%-fmleError: a (MaxPop-1)x1 vector that corresponds to the diagonal of the covariance matrix, that ammounts to the
%%variances for each of the parameters in the ff sector of the covariance matrix, with zeros for the
%%gauge fixed values
%%-VmleError: a (Nbins)x1 vector that corresponds to the diagonal of the covariance matrix, that ammounts to the
%%variances for each of the parameters in the VV sector of the covariance matrix
%%-CovMatmle(if gauge=0): a (MaxPop-1+Nbins) square, positive, symmetric, invertible
%%Matrix that corresponds to the covariance matrix of the asymptotic
%%gaussian distribution for the ML estimators. (if there was no gauge fix)
%%-CovMatmle(if gauge=1):a (MaxPop+Nbins) square, positive, symmetric, invertible
%%Matrix that corresponds to the covariance matrix of the asymptotic
%%gaussian distribution for the ML estimators after performing the gauge transformation
%%which ammounts to performing a similarity transformation to the covriance matrix
%%also we append to the asymptotic covariance the error and covariances of the parameter f(1) that was previously fixed but now has error. (if there was a gauge fix)


counts=cell2mat(struct2cell(load(str)));
tau=Corr(counts);
counts=counts';

%%
%setting up root values for the gradient search
alpharoot =  0.00010000;
gauge=0;
%gradient search with random seed
[fmle,Vmle,CovMatmle,fmleError,VmleError]=MLE('random',alpharoot,counts,gauge,tau);

%%
%plot params
if plots=='True'
    MaxPop=max(max(counts)); %maximum observed packing in the system
    Nbins=size(counts,1); %total number of bins

					  
    N=((1:(MaxPop+1))-1)'; %vector with possible occupation numbers in the system
    B=((1:(Nbins))-1)'; %vector with bin labels (by integers)


    ax1 = subplot(2,1,1);
    errorbar(N,fmle,fmleError)
    xlabel('Occupation # (N)')
    ylabel('Frustration f(N)')

    ax2 = subplot(2,1,2);
    errorbar(B,Vmle,VmleError)
    xlabel('Bin # (B)')
    ylabel('Vexation V(B)')
end
