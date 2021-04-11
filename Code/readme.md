Order in which to operate files

(1) code_for_returns.do

      input: daily  famma french factor, daily ESG market data, daily individual stock
      output: monthly data one matrix ready for preranking beta
      variable list order:kypermno expected_return_stock ESG_minus_rf market_minus_rf hml smb rmw cma tcap cal_year mmonth pre_ranked_beta_market


(2) stage_1_pre_rank.m

      input: take the imput from (1)
      output: the input from (1) plus the preranking beta fro market and ESG appended to end


(3) dealing_with_preranking.do

      input: the input from (1) plus the preranking beta fro market and ESG appended to end
      output: :"merged_portfolio_and_preranked_beta_data" this document has input plus beta decile, size decile, and a unique firm identifier!


(4) making_tables.do

      input: end of (3)
      output: excel files


(5) Cross_Sectional_Collapsing.do

      input: end of (3)
      output: a real nightmare of variables here is the list order kypermno expected_return_stock esg_minus_rf market_minus_rf hml smb rmw cma pre_ranked_beta_market pre_ranked_esg porfolio_decile beta_decile expected_stock_with_beta_mkcap average_pre_rank_beta average_mcap_log cal_year mmonth indexy_time_var

(6) mcbeth_maker.do

    input: end (3) i.e. merged_portfolio_and_preranked_beta_data
    output:  "out_of_stata_six_factor.csv" this is sported by unique_beta_and_mpportnum cal_year mmonth and has averages for the 6 factors

(7) cross_sectional_matlab.m

      input: end of (5)


(8)





Weird termonoloy conversion

   mretx --> expected_return_stock (it has got rid of the rf rate )
   ESG preranked values: pre_ranked_esg
   market preranked values: pre_ranked_beta_market


   ESG_minus_rf: is actually minus ESG daily returns minus the market and rf (we need to check if this is a good idea)

   https://www.connectedpapers.com/main/3e5e76163dee4f4b42492a4e0dfd9112fb432927/The-global-pricing-of-environmental-social-and-governance-ESG-criteria/graph
