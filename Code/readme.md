Order in which to operate files

(1) code_for_returns.do
      input: daily  famma french factor, daily ESG market data, daily individual stock
      output: monthly data one matrix ready for preranking beta
(2) stage_1_pre_rank.m
      input: take the imput from (1)
      output: the input from (1) plus the preranking beta fro market and ESG appended to end
(3) dealing_with_preranking.do
      input: the input from (1) plus the preranking beta fro market and ESG appended to end
      output: unsure???
(4) making_tables.do


variable list order
 kypermno expected_return_stock ESG_minus_rf market_minus_rf hml smb rmw cma tcap cal_year mmonth pre_ranked_beta_market

 conversion
    mretx --> 
