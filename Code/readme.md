Order in which to operate files

(1) code_for_returns.do

      input: daily  famma french factor, daily ESG market data, daily individual stock
      output: monthly data one matrix ready for preranking beta


(2) stage_1_pre_rank.m

      input: take the imput from (1)
      output: the input from (1) plus the preranking beta fro market and ESG appended to end


(3) dealing_with_preranking.do

      input: the input from (1) plus the preranking beta fro market and ESG appended to end
      output: :"merged_portfolio_and_preranked_beta_data" this document has input plus beta decil, size decile, and a unique firm identifier! it also outputs "input_for_crosssectional" but this seems sus b/c it is just a few sorts diff this will be addressed


(4) making_tables.do

      input: end of (3)
      output: excel files

      
(5) Cross_Sectional_Collapsing

variable list order
 kypermno expected_return_stock ESG_minus_rf market_minus_rf hml smb rmw cma tcap cal_year mmonth pre_ranked_beta_market

 conversion
    mretx --> expected_return_stock (it has got rid of the rf rate )


data nomanclature

ESG preranked values: pre_ranked_esg
market preranked values: pre_ranked_beta_market
