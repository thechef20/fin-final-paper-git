The main methology!


(1) code_for_returns.do

      input: daily  famma french factor, daily ESG market data, daily individual stock
      output: monthly data one matrix ready for preranking beta
      variable list order:kypermno expected_return_stock ESG_minus_rf market_minus_rf hml smb rmw cma tcap cal_year mmonth pre_ranked_beta_market



(2) dealing_with_preranking.do

      input: the input from (1) plus the preranking beta fro market and ESG appended to end
      output: : 2 different CSV files which have the collapsed values for beta and size portoflios


(3)FMB_in_stata.do

    input: take one of the two outputs from the (2) and than runs the FMB regression

    Output: FMB regressions step 1 and 2

(4) FMB_w_o_ESG.do
      Goal of this set is to look at the data w/o the ESG factor interacting to see what's good!!
      input: end of (5)



****Robustness checks***
!!Running the new portoflio's with industry!!

(1) Industry_ESG_analysis.do
--> this creates industry prolio reuslts

(1) FMB_time_trend.do

--> this will track the time effect of the EMP feeds in from the end of dealing with pre preranking

(1) SIC_universe.do
--> feeds in from  "Industry_ESG_analysis.do" half way through. this will explore to see if high minus low here has any mesurable effect 





Weird termonoloy conversion

   mretx --> expected_return_stock (it has got rid of the rf rate )
   ESG preranked values: pre_ranked_esg
   market preranked values: pre_ranked_beta_market


   ESG_minus_rf: is actually minus ESG daily returns minus the market and rf (we need to check if this is a good idea)

   https://www.connectedpapers.com/main/3e5e76163dee4f4b42492a4e0dfd9112fb432927/The-global-pricing-of-environmental-social-and-governance-ESG-criteria/graph
